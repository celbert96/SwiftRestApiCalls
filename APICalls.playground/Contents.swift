import UIKit
import Foundation

/*
 JSON protocols/functions
 */

protocol JSONInitializable {
    init?(_ json: [String: Any])
}

func parseJSONInitializableArray<T: JSONInitializable>(_ jsonArr: [[String: Any]]) -> [T]? {
    var arr: [T] = []
    for json in jsonArr {
        guard let el = T(json) else {
            return nil
        }
        
        arr.append(el)
    }
    
    return arr
}


/*
 Models
 */

struct ApiCallResult {
    let statusCode: Int
    let description: String
}

struct DiscordUser: JSONInitializable {
    let birthday: String
    let birthdayMessage: String
    let discordChannelID: String
    let discordUserID: String
    let uniqueID: Int
    let username: String
    
    init?(_ json: [String:Any]) {
        guard let birthday = json["birthday"] as? String,
              let birthdayMessage = json["birthdayMessage"] as? String,
              let discordChannelID = json["discordChannelID"] as? String,
              let discordUserID = json["discordUserID"] as? String,
              let uniqueID = json["uniqueID"] as? Int,
              let username = json["username"] as? String else {
            return nil
        }
        
        self.birthday = birthday
        self.birthdayMessage = birthdayMessage
        self.discordChannelID = discordChannelID
        self.discordUserID = discordUserID
        self.uniqueID = uniqueID
        self.username = username
              
    }
}


/*
 REST API Calls
 */

let baseUrl = "http://localhost:8080"

func getAllBirthdays() async throws {
    let endpoint = "/discordusers"
    guard let url = URL(string: baseUrl + endpoint) else {
        print("error - could not create URL object")
        return
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let jsonData = try JSONSerialization.jsonObject(with: data) as! [String: Any]
    
    let res: [DiscordUser]? = parseJSONInitializableArray(jsonData["data"] as! [[String: Any]])
    print(res)
}


/*
 "Main"
 */

Task {
    do {
        try await getAllBirthdays()
    } catch {
        print(error.localizedDescription)
    }
    
}

