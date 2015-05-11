//
//  HelperURLs.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/13/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

struct HelperURLs
{
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
    

}