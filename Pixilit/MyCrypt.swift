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
    
    static let key = "JLRcwQpE42efaz4TWkyf"
    
    static func encryptString(estring: String) -> String {
        var edata = MyRNEncryptor.encryptData(estring.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), password: key, error: nil)
        return edata.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
    }
}
            