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
        let Url: String
        let Description: String
        
        init(url: String, description: String)
        {
            Url = url
            Description = description
        }
    }
    
    var Title: String = ""
    var Thoroughfare: String = ""
    var Locality: String = ""
    var AdministrativeArea: String = ""
    var PostalCode: String = ""
    var Phone: String = ""
    var Email: String = ""
    var Website: String = ""
    var Hours: [String] = []
    var Description: String = ""
    var Logo: String = ""
    var Photos: [Photo] = []
    
    override init() { }
    
    init(json: JSON)
    {
        self.Title = json["title"].string!
        //self.Thoroughfare = json["field_address"]["und"][0]["thoroughfare"].string!
        //self.Locality = json["field_address"]["und"][0]["locality"].string!
        //self.AdministrativeArea = json["field_address"]["und"][0]["administrative_area"].string!
        //self.PostalCode = json["field_address"]["und"][0]["postal_code"].string!
        //self.Phone = json["field_phone_number"]["und"][0]["value"].string!
        //self.Email = json["field_email"]["und"][0]["email"].string!
        //self.Website = json["field_website"]["und"][0]["url"].string!
        //self.Hours = [String]()
        //self.Description = json["field_description"]["und"][0]["value"].string!
        self.Logo = json["field_logo"]["und"][0]["uri"].string!
        
                    if let photos = json["field_photos"]["und"].array
                    {
                            for p in photos
                            {
                                var uri = p["uri"].string!
                                var url = uri.stringByReplacingOccurrencesOfString(Config.FilePathPublicPlaceholder, withString: Config.FilePathPublicValue)
                                var desc = p["title"].string!
                                self.Photos.append(Photo(url: url, description: desc))
                            }
                    }
    }
}
