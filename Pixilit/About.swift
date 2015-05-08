//
//  About.swift
//  Pixilit
//
//  Created by SPT Pixilit on 5/8/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class About: NSObject, IRestful {
    
    private(set) var Title: String?
    private(set) var Body: String?
 
    
    override init() { }
    
    required init(json: JSON) {
        println(json)
        
        if let title = json["title"].string {
            self.Title = title
        }
        
        if let body = json["body"].string {
            self.Body = body
        }
     
    }
}
