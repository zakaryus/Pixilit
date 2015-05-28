//
//  Tag.swift
//  Pixilit
//
//  Created by SPT Pixilit on 5/27/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

public class Tag: NSObject, IRestful
{
    private(set) var Name: String?
    private(set) var TID: Int?

    override init() { }
    
    required public init(json: JSON) {
        if let name = json["name"].string {
            self.Name = name
        }
        
        if let tid = json["tid"].string {
            var num : Int = tid.toInt()!
            self.TID = num
        }
    }
}