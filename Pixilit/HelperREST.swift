//
//  HelperREST.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/13/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

struct HelperREST
{
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
    
    static func RestNidToTile(Nid: String, CompletionHandler: (tile: Tile) -> ()) {
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
    
    static func RestUserFlags(Uid: String, CompletionHandler: (tiles: [Tile]) -> ()) {
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
}
