//
//  Tile.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/20/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

public class Tile: NSObject, IRestful {
    
    private(set) var Description: String?
    private(set) var Photo: String?
    private(set) var Nid : String?
    private(set) var BusinessID: String?
    private var _Pixd: Bool = false
    var Pixd: Bool? {
        get { return _Pixd }
        set(value) { _Pixd = value! }
    }
    private(set) var tags: [String] = []
    private(set) var BusinessName: String?
    private(set) var BusinessLogo: String?
    
    private(set) var PhotoMetadata: CGSize?
    
    override init() { }
    
    //based on parsing from pixilit.com/rest/businesstile.json?nid=xxx
    required public init(json: JSON) {
        super.init()
        if let title = json["description"].string {
            self.Description = title
        }
        
        if let photo = json["photo"].string {
            self.Photo = photo
        }
        
        if let nid = json["nid"].string {
            self.Nid = nid
        }
        
        if let businessid = json["parent_uid"].string {
            self.BusinessID = businessid
        }
        
        if let pixd = json["pixd"].string {
          
            if(User.IsLoggedIn())
            {
                var content = "{\"flag_name\":\"pixd\",\"entity_id\":\"\(self.Nid!)\",\"uid\":\"\(User.Uid)\"}"
                var success = HelperREST.RestRequest(Config.RestIsFlagged, content: content, method: HelperREST.HTTPMethod.Post,  headerValues: [("X-CSRF-Token",User.Token)])

                if success[0].stringValue == "true"
                {
                    self.Pixd = true
                }
            }
         
            
        }
        if let tags = json["Tags"].array {
           
            for tag in tags {
                self.tags.append(tag.string!)
                         }
        }
        if let businessname = json["parent_name"].string {
            self.BusinessName = businessname
        }
        
        if let businesslogo = json["parent_logo"].string {
            self.BusinessLogo = businesslogo
        }
        
        if let photowidth = json["photo_metadata"]["width"].string {
            if let photoheight = json["photo_metadata"]["height"].string {
                if let width = NSNumberFormatter().numberFromString(photowidth) {
                    if let height = NSNumberFormatter().numberFromString(photoheight) {
                        
                    
                        var w = CGFloat(width)
                        var h = CGFloat(height)
                        PhotoMetadata = CGSizeMake(w, h)
                    }
                }
            }
        } else {
            PhotoMetadata = CGSizeMake(0, 0)
        }
    }
}
