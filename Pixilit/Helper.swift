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
    static func UrlToImage(Url: String) -> UIImage
    {
        var uri = Url
        var imgPath = uri.stringByReplacingOccurrencesOfString(Config.FilePathPublicPlaceholder, withString: Config.FilePathPublicValue)
        let imgUrl = NSURL(string: imgPath)
        let imgData = NSData(contentsOfURL: imgUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        return UIImage(data: imgData!)!
    }
    
    static func RestContentTypeRequest(ContentType: String, CompletionHandler: (Urls: [String]) -> ())
    {
        var tmpUrls = [String]()
        
        let urlPath = Config.RestNodeIndex
        
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
    
//    static func RestUrlToContent(Urls: [String], CompletionHandler: (Items: [Business]) -> ())
//    {
//        let group: dispatch_group_t = dispatch_group_create()
//        
//        dispatch_group_enter(group)
//        
//        var content = [Business]()
//
//        for url in Urls
//        {
//            var tmp: Business = Business()
//            tmp.Create(url) {
//                Item in
//                tmp = Item
//                println("Title: \(tmp.Title)")
//                content.append(tmp)
//                
//                dispatch_group_leave(group)
//            }
//            
//            println(content.count)
//        }
//        
//        dispatch_group_notify(group, dispatch_get_main_queue(),
//        {
//            CompletionHandler(Items: content)
//        })
//    }
    
    static func RestUrlToContent(Urls: [String], CompletionHandler: (Items: [Business]) -> ())
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
                println(content.count)
                
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
