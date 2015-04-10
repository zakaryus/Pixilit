//
//  Region.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/10/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class Region: NSObject
{
    var Name: String?
    var TID: Int?
    var PID: Int?
    
    
    override init() { }
    
    init(json: JSON) {
        if let name = json["name"].string {
            self.Name = name
        }
        
        if let tid = json["tid"].int {
            self.TID = tid
        }
        
        if let pid = json["pid"].int{
            self.PID = pid
        }
    }
    
}