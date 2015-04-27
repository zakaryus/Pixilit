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
    
    static func RestRegionsRequest(CompletionHandler: (Regions: [Region]) -> ()) {
        var tmpRegions = [Region]()
        
        let urlPath = Config.RestRegionsJson
        
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
                
                var region = Region(json: subJson)
                tmpRegions.append(region)
            }
            
            //tmpUrls = tmpUrls.sorted({$0.Title < $1.Title})
            
            CompletionHandler(Regions: tmpRegions)
        })
        task.resume()
    }
    
    static func RestFlag(entityID : String, pixd : Bool, CompletionHandler: (Success : Bool) -> ()) {
        
        let urlPath = Config.RestFlagJson
        let url: NSURL = NSURL(string: urlPath)!
        
        var flagged: String = "flag"
      
              if  pixd == true {
            flagged = "unflag"
        }
        
        var post:NSString = "{\"flag_name\":\"pixd\",\"entity_id\":\"\(entityID)\",\"uid\":\"\(User.Uid)\",\"action\":\"\(flagged)\"}"
        println(post)
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:NSString = String(postData.length )
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        var data: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        var json = JSON(data: data!)
        var success : Bool = false
        
        for (index: String, subJson: JSON) in json {
        
            if subJson.stringValue == "true"
            {
                success = true
            }

        break
        }
        CompletionHandler(Success: success)
        
        
    }
    
    static func RestIsFlagged(entityID : String) -> Bool {
        
        let urlPath = Config.RestIsFlagged
        println("inside flagg")
        println(User.Uid)
        println("THE uid IS PRINTED RIGHT ABOVE")
        println(User.Token)
          println("THE token IS PRINTED RIGHT ABOVE")
        let url: NSURL = NSURL(string: urlPath)!
        
        var post:NSString = "{\"flag_name\":\"pixd\",\"entity_id\":\"\(entityID)\",\"uid\":\"\(User.Uid)\"}"
        println(post)
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:NSString = String(postData.length )
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        var data: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        var json = JSON(data: data!)
        var success : Bool = false
        println(json)
        for (index: String, subJson: JSON) in json {
            
                     
            
            if subJson.stringValue == "true"
            {
                success = true
            }
      
        }
        return success
        
        
    }
    
    
    
 
    
    static func RestFacebook(accessToken: String) {
        
        let urlPath = Config.RestFacebookConnect
        let url: NSURL = NSURL(string: urlPath)!
        
        var post:NSString = "{\"access_token\":\"\(accessToken)\"}"
        println(post)
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:NSString = String(postData.length )
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        var data: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        var json = JSON(data: data!)
        var success : Bool = false
        println(json)
        User.userSetup(json)
        println("USEIJRISJDIJFIJSDF")
        println(User.Uid)
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
    
    static func RestBusinessRequest(Uid: String, CompletionHandler: (Business: Business) -> ()) {
        var business = Business()
        
        let urlPath = Config.RestBusinessJson + Uid
        
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
                
                business = Business(json: subJson)
                break
            }
  
            
            //tmpUrls = tmpUrls.sorted({$0.Title < $1.Title})
            
            CompletionHandler(Business: business)
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
        println("inside RestMainFeedRequest")
        println(User.Uid)
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
        println("inside restUserFlagged")
        println(User.Uid)
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
