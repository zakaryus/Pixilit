
import UIKit

enum AccountType : String{
    case User = "user"
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
        if let role = json["user"]["field_account_type"]["und"][0]["value"].string {
            switch role.lowercaseString {
                case "business" :
                    Role = .Business
                case "user" :
                    Role = .User
                default :
                    Role = .User
            }
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
