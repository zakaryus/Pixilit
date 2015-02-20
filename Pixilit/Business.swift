//
//  Business.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class Business: NSObject
{
    struct Photo
    {
        let Url: String?
        let Description: String?
        
        init(url: String, description: String)
        {
            Url = url
            Description = description
        }
    }
    
    var Title: String?
    var Thoroughfare: String?
    var Locality: String?
    var AdministrativeArea: String?
    var PostalCode: String?
    var Phone: String?
    var Email: String?
    var Website: String?
    var Hours: [String] = []
    var Description: String?
    var Logo: String?
    var PixilitURL: String?
    var Photos: [Photo] = []
    var Pix: [String] = []
    
    
    override init() { }
    
//based on parsing from pixilit.com/rest/businesses.json
    init(json: JSON)
    {
        if let title = json["title"].string {
            self.Title = title
        }
        
        if let thoroughfare = json["thoroughfare"].string {
            self.Thoroughfare = thoroughfare
        }
        
        if let locality = json["locality"].string {
            self.Locality = locality
        }
        
        if let administrativearea = json["administrative_area"].string {
            self.AdministrativeArea = administrativearea
        }
        
        if let postalcode = json["postal_code"].string {
            self.PostalCode = postalcode
        }
        
        if let phone = json["phone"].string {
            self.Phone = phone
        }
        
        if let email = json["email"].string {
            self.Email = email
        }
        
        if let website = json["website"].string {
            self.Website = website
        }
        
        self.Hours = [String]()
        
        if let description = json["description"].string {
            self.Description = description
        }
        
        if let logo = json["logo"].string {
            self.Logo = logo
        }
        
<<<<<<< HEAD
        if let pix = json["pix"].array {
            for p in pix {
                if let nid = p["target_id"].string {
                    self.Pix.append(nid)
                    println(nid)
                }
=======
        if let nid = json["nid"].string {
            self.PixilitURL = Config.NodePath + nid
        }
        
        if let photos = json["photos"].array {
            for p in photos
            {
                var url = p.string!
                var desc = json["title"].string!    //need to figure out how to get photo title
                self.Photos.append(Photo(url: url, description: desc))
>>>>>>> FETCH_HEAD
            }
        }
    }
    
//based on parsing from pixilit.com/rest/node.json
//    init(json: JSON)
//    {
//        if let title = json["title"].string {
//            self.Title = title
//        }
//        
//        if let thoroughfare = json["field_address"]["und"][0]["thoroughfare"].string {
//            self.Thoroughfare = thoroughfare
//        }
//        
//        if let locality = json["field_address"]["und"][0]["locality"].string {
//            self.Locality = locality
//        }
//        
//        if let administrativearea = json["field_address"]["und"][0]["administrative_area"].string {
//            self.AdministrativeArea = administrativearea
//        }
//        
//        if let postalcode = json["field_address"]["und"][0]["postal_code"].string {
//            self.PostalCode = postalcode
//        }
//        
//        if let phone = json["field_phone_number"]["und"][0]["value"].string {
//            self.Phone = phone
//        }
//        
//        if let email = json["field_email"]["und"][0]["email"].string {
//            self.Email = email
//        }
//        
//        if let website = json["field_website"]["und"][0]["url"].string {
//            self.Website = website
//        }
//        
//        self.Hours = [String]()
//        
//        if let description = json["field_description"]["und"][0]["value"].string {
//            self.Description = description
//        }
//        
//        if let logo = json["field_logo"]["und"][0]["uri"].string {
//            self.Logo = logo
//        }
//        
//        if let photos = json["field_photos"]["und"].array {
//            for p in photos
//            {
//                var uri = p["uri"].string!
//                var url = uri.stringByReplacingOccurrencesOfString(Config.FilePathPublicPlaceholder, withString: Config.FilePathPublicValue)
//                var desc = p["title"].string!
//                self.Photos.append(Photo(url: url, description: desc))
//            }
//        }
//    }
}
