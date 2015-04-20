//
//  NewsPage.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/2/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class NewsPage: NSObject, IRestful {
    
    private(set) var Title: String?
    private(set) var Body: String?
    private(set) var Date: NSDate?
    
    override init() { }
    
    //based on parsing from pixilit.com/rest/businesstile.json?nid=xxx
    required init(json: JSON) {
        println(json)
        
        if let title = json["title"].string {
            self.Title = title
        }
        
        if let body = json["body"].string {
            self.Body = body
        }
        
        if let date = json["date"].string {
            var dblDate = (date as NSString).doubleValue
            var interval = NSTimeInterval(dblDate)
            var tmpDate = NSDate(timeIntervalSince1970: interval)
            self.Date = tmpDate
        }
    }
}
