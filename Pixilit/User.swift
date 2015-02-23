
import UIKit

class User: NSObject
{
   
    var Pixd = [String]()
    var Username: String!
    var Uid: String!
    override init() { }
    
    init(json: JSON)
    {
        if let uid = json["user"]["uid"].string {
            self.Uid = uid
        }
        if let name = json["user"]["name"].string {
            self.Username = name
        }
 
    }

    
    func appendPixd(json: JSON)
    {
        
        if let list = json.array {
            for p in list {
                if let nid = p["nid"].string {
                    self.Pixd.append(nid)
                }
            }
        }

       
    }
    
}
