
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
    private(set) static var SessionName : String!
    private(set) static var Sessid : String!
    private(set) static var Cookie : String!
 
    private(set) static var Profile : NSMutableDictionary!
    
    static func Setup(json: JSON)
    {
        println(json)
        var data = json.rawData(options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        var tmpDict = (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers, error: nil) as! NSMutableDictionary)["user"] as! NSMutableDictionary!
        tmpDict = tmpDict["profile"] as! NSMutableDictionary!
        Profile = tmpDict["all"] as! NSMutableDictionary!

        if let uid = json["user"]["uid"].string {
            Uid = uid
        }
        if let name = json["user"]["name"].string {
           Username = name
    
        }
        if let token = json["token"].string {
           Token = token
        }
        if let role = json["user"]["profile"]["all"]["type"].string {
            switch role.lowercaseString {
                case "business" :
                    Role = .Business
                case "basic" :
                    Role = .User
                default :
                    Role = .Admin
            }
        }

        
   
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
            }
        }
        if let pid = json["user"]["profile"]["all"]["pid"].string {
            Pid = pid

        }
    }
    

    private static func SetRegions() {
        
        if let regions = Profile["field_user_regions"] as? NSMutableDictionary
        {
            if let und = regions["und"] as? NSMutableArray
            {
                var tidHolder = ""
                var first = true
                for tid in  und {
                    var tmpTid = (tid as! NSDictionary).valueForKey("tid") as! String
                    if first {
                        tidHolder += tmpTid
                        first = false
                    }
                    else {
                        tidHolder += ",\(tmpTid)"
                    }
                }
                
                var semaphore = dispatch_semaphore_create(0)
                
              
                    HelperREST.RestRegionsRequest(tid: tidHolder) {
                        Regs in
                        self.Regions = Regs
                        dispatch_semaphore_signal(semaphore)
                    }
                
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
          
            }
        }

        
    }
    
    
    static func SetAnonymous()
    {
        Username = "Anonymous"
        Token = ""
        Uid = "-1"
        Role = .Anonymous
        Regions = []
        Pid = ""
        SessionName = ""
        Sessid = ""
        Cookie = ""
    }
    
    static func Logout()
    {
        var json : JSON = HelperREST.RestRequest(Config.RestUserLogout, content: nil, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
        println("json: \(json)")
        SetAnonymous()
    }
    
    static func IsLoggedIn() -> Bool
    {
        return Uid != "-1"
    }
    
    static func SetSession(sessname : String, sessid : String)
    {
        SessionName = sessname
        Sessid = sessid
        Cookie = sessname + "=" + sessid 
    
    }
    
    static func setToken(token : String)
    {
        Token = token
    }
    
    static func AddRegion(tid: String) -> Bool {
       
        var tmpProfile = Profile
        
        if let regions = tmpProfile["field_user_regions"] as? NSMutableDictionary
        {
            if let und = regions["und"] as? NSMutableArray
            {
                und.addObject(["tid":"\(tid)"])
               
                var put: NSString = NSString(data: JSON(tmpProfile).rawData(options: NSJSONWritingOptions.allZeros, error: nil)!, encoding: NSUTF8StringEncoding)!
                var json = HelperREST.RestRequest(Config.RestUserProfile + Pid, content: put as String, method: HelperREST.HTTPMethod.Put, headerValues: [("X-CSRF-Token", User.Token)])
            
                Profile = tmpProfile
                SetRegions()
                return true
            }

        }
        return false 
    }
    
    static func RemoveRegion(tid: String) -> Bool {
        var tmpProfile = Profile
        
        if let regions = tmpProfile["field_user_regions"] as? NSMutableDictionary
        {
            if let und = regions["und"] as? NSMutableArray
            {
                und.removeObject(["tid":"\(tid)"])
                
                var put: NSString = NSString(data: JSON(tmpProfile).rawData(options: NSJSONWritingOptions.allZeros, error: nil)!, encoding: NSUTF8StringEncoding)!
                var json = HelperREST.RestRequest(Config.RestUserProfile + Pid, content: put as String, method: HelperREST.HTTPMethod.Put, headerValues: [("X-CSRF-Token", User.Token)])
                
                Profile = tmpProfile
                SetRegions()
                return true
            }
            
        }
        return false
    }
}
