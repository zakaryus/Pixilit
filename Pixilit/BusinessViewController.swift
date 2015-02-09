//
//  BusinessViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 2/2/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController {
    
    @IBOutlet weak var businessNavBar: UINavigationItem!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessThoroughfare: UILabel!
    @IBOutlet weak var businessLocalityAdminZip: UILabel!
    @IBOutlet weak var businessPhone: UILabel!
    @IBOutlet weak var businessEmail: UILabel!
    @IBOutlet weak var businessWebsite: UILabel!
    @IBOutlet weak var businessDescription: UILabel!
    @IBOutlet weak var businessLogo: UIImageView!
    
    var nid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlPath = nid
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                    
                var json = JSON(data: data)
                self.businessName.text = json["title"].string
                self.businessNavBar.title = json["title"].string
                
                self.businessThoroughfare.text = json["field_address"]["und"][0]["thoroughfare"].string!
                var locality = json["field_address"]["und"][0]["locality"].string!
                var aa = json["field_address"]["und"][0]["administrative_area"].string!
                var post = json["field_address"]["und"][0]["postal_code"].string!
                self.businessLocalityAdminZip.text = "\(locality), \(aa) \(post)"
                self.businessPhone.text = json["field_phone_number"]["und"][0]["value"].string
                self.businessEmail.text = json["field_email"]["und"][0]["email"].string
                
                //hours
                
                self.businessDescription.text = json["field_description"]["und"][0]["safe_value"].string
                
                var uri = json["field_logo"]["und"][0]["uri"].string
                var imgPath = uri?.stringByReplacingOccurrencesOfString("public:", withString: "http://www.pixilit.com/sites/default/files/")
                let imgUrl = NSURL(string: imgPath!)
                let imgData = NSData(contentsOfURL: imgUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                self.businessLogo.image = UIImage(data: imgData!)
            
            })
        })
        task.resume()        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    }
    
    
}
