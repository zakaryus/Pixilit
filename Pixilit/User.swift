
import UIKit

enum AccountType : String{
    case Basic = "basic"
    case Business = "business"
    case Anonymous = "anonymous"
    case Admin = "administrator"
}

struct User
{
    static var Username: String!
    static var Token: String!
    static var Uid: String!
    static var Role: AccountType!
    
    static func userSetup(json: JSON)
    {
        if let uid = json["user"]["uid"].string {
            Uid = uid
        }
        if let name = json["user"]["name"].string {
           Username = name
    
        }
        if let token = json["token"].string {
           Token = token
        }
        
        SetRole(.Basic, index: "5", json: json)
        SetRole(.Business, index: "4", json: json)
        SetRole(.Admin, index: "3", json: json)
    
    }
    
    static func SetRole(accountType: AccountType, index: String, json: JSON) {
        let roles = json["user"]["roles"][index].string
        
        if let r = roles{
            Role = accountType
        }
    }
    
    static func SetAnonymous()
    {
        Username = "Anonymous"
        Uid = "-1"
        Token = ""
        Role = .Anonymous
    }
    
    static func Logout()
    {
        SetAnonymous()
    }
}
