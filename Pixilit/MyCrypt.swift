//
//  MyCrypt.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/7/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit
import Foundation

struct MyCrypt{
    
    static func encryptString(estring: String) -> String {
        var rtn:(key: String, password: String)
        
        rtn.key = MyCrypt.randomStringWithLength(20)
        var edata = MyRNEncryptor.encryptData(estring.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), password: rtn.key, error: nil)
        rtn.password = edata.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        
        return rtn.0 + rtn.1
    }
    
    
    static func randomStringWithLength (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
    }
    

}
            