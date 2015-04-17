//
//  Tile.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/20/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class Tile: NSObject, IRestful {
    
    var Description: String?
    var Photo: String?
    var BusinessID: String?
    var Pixd: Bool?
    var tags: [String] = []
    var BusinessLogo: String?
    var BusinessName: String?
    
    override init() { }
    
    //based on parsing from pixilit.com/rest/businesstile.json?nid=xxx
    required init(json: JSON) {
        if let title = json["description"].string {
            self.Description = title
        }
        
        if let photo = json["photo"].string {
            self.Photo = photo
        }
        
        if let businessid = json["parent_uid"].string {
            self.BusinessID = businessid
        }
        
        if let pixd = json["pixd"].string {
            self.Pixd = pixd == "1"
        }
        if let tags = json["Tags"].array {
        
            for tag in tags {
                self.tags.append(tag.string!)
                println("Tag: \(tag)")
            }
        }
        if let businessname = json["parent_name"].string {
            self.BusinessName = businessname
        }
        if let businesslogo = json["parent_logo"].string {
            self.BusinessLogo = businesslogo
        }
    }
}
