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
    
    override init() { }
    
    //based on parsing from pixilit.com/rest/businesstile.json?nid=xxx
    init(json: JSON) {
        if let title = json[0]["description"].string {
            self.Description = title
        }
        
        if let photo = json[0]["photo"].string {
            self.Photo = photo
        }
    }
}
