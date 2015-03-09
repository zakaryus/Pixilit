//
//  Helper.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

struct Helper
{
    //URLS
    static func UrlToImage(Url: String, CompletionHandler: (Image: UIImage) -> ()) {
        var tmpImage: UIImage
        
        var uri = Url
        var imgPath = uri.stringByReplacingOccurrencesOfString(Config.FilePathPublicPlaceholder, withString: Config.FilePathPublicValue)
        let imgUrl = NSURL(string: imgPath)
        if let imgData = NSData(contentsOfURL: imgUrl!) {
            tmpImage = UIImage(data: imgData)!
        }
        else {
            tmpImage = UIImage()
        }
        
        CompletionHandler(Image: tmpImage)
    }
    
    static func UidToUserUrl(Uid: String) -> String {
        return Config.UserPath + Uid
    }
    
    static func NidToTile(Nid: String, CompletionHandler: (tile: Tile) -> ()) {
        let urlPath = Config.RestBusinessTileJson + Nid
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var json = JSON(data: data)
            var tmpTile: Tile = Tile()
            
            for (index: String, subJson: JSON) in json {
                
                //println(subJson)
                
                tmpTile = Tile(json: subJson)
                break
            }
            
            CompletionHandler(tile: tmpTile)
        })
        task.resume()
    }
    
    static func userFlags(Uid: String, CompletionHandler: (tiles: [Tile]) -> ())
    {
        var tmpTiles = [Tile]()
        let urlPath = Config.UserFlagsJson + Uid
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var json = JSON(data: data)
            
            for (index: String, subJson: JSON) in json {
                
                println(subJson)
                
                var tmpTile = Tile(json: subJson)
                tmpTiles.append(tmpTile)
            }
            
            //tmpUrls = tmpUrls.sorted({$0.Title < $1.Title})
            
            CompletionHandler(tiles: tmpTiles)
            
            
        })
        task.resume()
        
        
    }
    
    
    //STRINGIFY
    //From: http://apexappdev.com/date-to-month-day-year-in-swift/
    static func NSDateToString(date: NSDate) -> String {
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        
        return "\(month)/\(day)/\(year)"
    }
    
    
    
    //REST
    static func RestBusinessesRequest(CompletionHandler: (Businesses: [Business]) -> ()) {
        var tmpBusinesses = [Business]()
        
        let urlPath = Config.RestBusinessesJson
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }

            var json = JSON(data: data)
            //println(json)
            
            for (index: String, subJson: JSON) in json {
                
                //println(subJson)
                
                var business = Business(json: subJson)
                tmpBusinesses.append(business)
            }
            
            //tmpUrls = tmpUrls.sorted({$0.Title < $1.Title})
            
            CompletionHandler(Businesses: tmpBusinesses)
        })
        task.resume()
    }
    
    static func RestMainNewsPageRequest(CompletionHandler: (newspage: [NewsPage]) -> ()) {
        var tmpNewsPages = [NewsPage]()
        
        let urlPath = Config.RestMainNewsPageJson
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var json = JSON(data: data)
            
            for (index: String, subJson: JSON) in json {
                
                var tmpNewsPage = NewsPage(json: subJson)
                tmpNewsPages.append(tmpNewsPage)
            }
            
            CompletionHandler(newspage: tmpNewsPages)
        })
        task.resume()
    }
    
    static func RestMainFeedRequest(CompletionHandler: (tiles: [Tile]) -> ()) {
        var tmpTiles = [Tile]()
        
        let urlPath = Config.RestMainFeedJson
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var json = JSON(data: data)
            
            for (index: String, subJson: JSON) in json {
                
                println(subJson)
                var tmpTile = Tile(json: subJson)
                tmpTiles.append(tmpTile)
            }
            
            CompletionHandler(tiles: tmpTiles)
        })
        task.resume()
    }
}
