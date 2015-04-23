
import UIKit

enum AccountType : String{
    case User = "user"
    case Business = "business"
    case Anonymous = "anonymous"
    case Admin = "administrator"
}

struct User
{
    private(set) static var Username: String!
    private(set) static var Token: String!
    private(set) static var Uid: String!
    private(set) static var Role: AccountType!
    
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
            println("TOKEN")
            println(Token)
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
    
    static func facebookUsernameSet(newName: String)
    {
        Username = newName
        Role = .User
        println("INSIDE USER")
        println(Username)
        //Uid = "12345678"
        
        
    }
    static func facebookIDSet(uid: String)
    {
  
        Uid = uid
        println("INSIDE ID")
        println(Uid)
        
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
