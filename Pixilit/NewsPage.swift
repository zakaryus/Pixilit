//
//  NewsPage.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/2/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class NewsPage: NSObject {
    var Title: String?
    var Body: String?
    var Date: NSDate?
    
    override init() { }
    
    //based on parsing from pixilit.com/rest/businesstile.json?nid=xxx
    init(json: JSON) {
        if let title = json["title"].string {
            self.Title = title
        }
        
        if let body = json["body"].string {
            self.Body = body
        }
        
        if let date = json["date"].double {
            var tmpDate = NSDate(timeIntervalSince1970: date)
            self.Date = tmpDate
        }
    }
}
