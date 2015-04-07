//
//  MyCrypt.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/7/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit
import Foundation

class MyCrypt: NSObject {
    
    let key = "MySecretPassword"
    

    
    func encryptString(estring: String) -> NSData {
        var edata = MyRNEncryptor.encryptData(estring.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), password: key, error: nil)
        
        return edata
    }
    
    func decryptData(edata: NSData) -> String {
        
        var pdata = RNDecryptor.decryptData(edata, withPassword: key, error: nil)
        var pstring: String = MyRNEncryptor.stringFromData(pdata)
        return pstring
    }

}
