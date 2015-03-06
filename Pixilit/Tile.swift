//
//  Tile.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/20/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class Tile: NSObject {
    var Description: String?
    var Photo: String?
    var BusinessID: String?
    var Pixd: Bool?
    
    override init() { }
    
    //based on parsing from pixilit.com/rest/businesstile.json?nid=xxx
    init(json: JSON) {
        if let title = json[0]["description"].string {
            self.Description = title
        }
        
        if let photo = json[0]["photo"].string {
            self.Photo = photo
        }
        
        if let businessid = json[0]["bid"].string {
            self.BusinessID = businessid
        }
        
        if let pixd = json[0]["pixd"].string {
            self.Pixd = pixd == "1"
        }
    }
}
