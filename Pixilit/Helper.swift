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
    static func UrlToImage(Url: String, CompletionHandler: (Image: UIImage) -> ())
    {
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
    
    static func RestBusinessesRequest(CompletionHandler: (Businesses: [Business]) -> ())
    {
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
            //println(json)
            
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

    static func NidToTile(Nid: String, CompletionHandler: (tile: Tile) -> ())
    {
        let urlPath = Config.RestBusinessTileJson + Nid
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var json = JSON(data: data)
            
            var tmpTile = Tile(json: json)
            
            CompletionHandler(tile: tmpTile)
        })
        task.resume()
    }
    
    static func RestContentTypeRequest(ContentType: String, CompletionHandler: (Urls: [String]) -> ())
    {
        var tmpUrls = [String]()
        
        let urlPath = Config.RestBusinessesJson
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                var json = JSON(data: data)
                //println(json)
                
                for (index: String, subJson: JSON) in json {
                    
                    //println(subJson)
                    
                    if subJson["type"].string == ContentType
                    {
                        var content: String = subJson["uri"].string! + ".json"
                        tmpUrls.append(content)
                    }
                }
                
                //tmpUrls = tmpUrls.sorted({$0.Title < $1.Title})
                
                CompletionHandler(Urls: tmpUrls)
                
            })
        })
        task.resume()
    }
    
    static func RestUrlToContentxasdgf(Urls: [String], CompletionHandler: (Items: [Business]) -> ())
    {
        var content = [Business]()
        let group = dispatch_group_create()
        
        
        for Url in Urls
        {
            dispatch_group_enter(group)
            
            let url: NSURL = NSURL(string: Url)!
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                if((error) != nil) {
                    //If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                }
                
                var json = JSON(data: data)
                
                var tmp: Business = Business(json: json)
                content.append(tmp)
                //println(content.count)
                
                dispatch_group_leave(group)
            })
            task.resume()
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(),
        {
            CompletionHandler(Items: content)
        })
    }
}
