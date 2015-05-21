//
//  HelperJsonConversion.swift
//  Pixilit
//
//  Created by SPT Pixilit on 5/20/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

public struct HelperJsonConversion
{
    public static func JsonToTiles(json: JSON) -> [Tile] {
        
        var tmpTiles: [Tile] = []
        
        for (index: String, subJson: JSON) in json {
            var tmpTile = Tile(json: subJson)
            tmpTiles.append(tmpTile)
        }
        
        return tmpTiles
    }
    
    public static func JsonToTile(json: JSON) -> Tile {
        
        var tmpTile: Tile!
        
        for (index: String, subJson: JSON) in json {
            tmpTile = Tile(json: subJson)
            break
        }
        
        return tmpTile
    }
}
