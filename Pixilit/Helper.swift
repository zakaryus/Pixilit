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
    static func UrlToImage(url: String) -> UIImage
    {
        var uri = url
        var imgPath = uri.stringByReplacingOccurrencesOfString(Config.FilePathPublicPlaceholder, withString: Config.FilePathPublicValue)
        let imgUrl = NSURL(string: imgPath)
        let imgData = NSData(contentsOfURL: imgUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        return UIImage(data: imgData!)!
    }
}
