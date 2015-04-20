//
//  Business.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class Business: NSObject, IRestful
{
    private(set) var Title: String?
    private(set) var Thoroughfare: String?
    private(set) var Locality: String?
    private(set) var AdministrativeArea: String?
    private(set) var PostalCode: String?
    private(set) var Phone: String?
    private(set) var Email: String?
    private(set) var Website: String?
    private(set) var Hours: [String] = []
    private(set) var Description: String?
    private(set) var Logo: String?
    private(set) var Pix: [String] = []
    private(set) var Uid: String?
    
   override init() { }
    
//based on parsing from pixilit.com/rest/businesses.json
    required init(json: JSON)
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
        
        if let uid = json["uid"].string {
            self.Uid = uid
        }
    }
}
