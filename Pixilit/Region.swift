//
//  Region.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/10/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class Region: NSObject, IRestful
{
    private(set) var Name: String?
    private(set) var TID: Int?
    private(set) var PID: Int?
    
    override init() { }
    
    required init(json: JSON) {
        if let name = json["region"].string {
            self.Name = name
        }
        
        if let tid = json["tid"].string {
            var num : Int = tid.toInt()!
            self.TID = num
        }
        
        self.PID = 0
        if let pid = json["pid"].string {
            var num : Int = pid.toInt()!
            self.PID = num
        }
    }
    
}