
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
    private(set) static var Regions:[Region] = []
    private(set) static var Pid: String!
    
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
        var abc = json["user"]["profile"]["regions"]
        
   
        if let tids = json["user"]["profile"]["regions"].array {
            var tidHolder : String = ""
            var first = true
            for tid in tids {
                var tmpTid = tid["tid"].stringValue
                if first {
                    tidHolder += tmpTid
                    first = false
                }
                else {
                    tidHolder += ",\(tmpTid)"
                }
            }
            
            HelperREST.RestRegionsRequest(tid: tidHolder) {
                Regs in
                self.Regions = Regs
                for fuck in self.Regions {
                    println(fuck.Name)
                }
            }
        }
        if let pid = json["pid"].string {
            Pid = pid

        }
    }
    
    static func UserProfile(json: JSON)
    {
        
        
        
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
    
    static func isLoggedIn() -> Bool
    {
        return Uid != "-1"
    }
}
