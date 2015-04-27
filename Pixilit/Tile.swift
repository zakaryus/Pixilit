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
    private var _Pixd: Bool?
    var Pixd: Bool? {
        get { return _Pixd }
        set(value) { _Pixd = value }
    }
    private(set) var tags: [String] = []
    private(set) var BusinessName: String?
    private(set) var BusinessLogo: String?
    
    private(set) var PhotoMetadata: CGSize?
    
    override init() { }
    
    //based on parsing from pixilit.com/rest/businesstile.json?nid=xxx
    required init(json: JSON) {
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
            self.Pixd = HelperREST.RestIsFlagged(self.Nid!)
                   }
        if let tags = json["Tags"].array {
            println(json)
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
        
        if let photowidth = json["photo_metadata"]["width"].string {
            if let photoheight = json["photo_metadata"]["height"].string {
                if let width = NSNumberFormatter().numberFromString(photowidth) {
                    if let height = NSNumberFormatter().numberFromString(photoheight) {
                        
                        println("photo width: \(width), height: \(height)")
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
