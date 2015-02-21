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
    var Pix: [String] = []
    var PixilitUrl: String?
    
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
        
        if let pix = json["pix"].array {
            for p in pix {
                if let nid = p["target_id"].string {
                    self.Pix.append(nid)
                    println(nid)
                }
            }
        }
        
        if let pixiliturl = json["pixiliturl"].string {
            self.PixilitUrl = pixiliturl
        }
    }
}
