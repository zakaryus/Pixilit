//
//  Tile.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/20/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class Tile: NSObject, IRestful {
    
    private(set) var Description: String?
    private(set) var Photo: String?
    private(set) var Nid : String?
    private(set) var BusinessID: String?
    private(set) var Pixd: Bool?
    private(set) var tags: [String] = []
    
    override init() { }
    
    //based on parsing from pixilit.com/rest/businesstile.json?nid=xxx
    required init(json: JSON) {
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
            self.Pixd = pixd == "1"
        }
        if let tags = json["Tags"].array {
        
            for tag in tags {
                self.tags.append(tag.string!)
                println("Tag: \(tag)")
            }
        }
    }
}
