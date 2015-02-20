//
//  Config.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

let dict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!)

struct Config
{
    static let RestBusinessIndex: String = dict?.objectForKey("RestBusinessIndex") as String
    static let RestBusinessesIndex: String = dict?.objectForKey("RestBusinessesIndex") as String
    static let ContentTypeBusiness: String = dict?.objectForKey("ContentTypeBusiness") as String
    static let FilePathPublicPlaceholder: String = dict?.objectForKey("FilePathPublicPlaceholder") as String
    static let FilePathPublicValue: String = dict?.objectForKey("FilePathPublicValue") as String
    static let AppTitle: String = dict?.objectForKey("AppTitle") as String
    static let NodePath: String = dict?.objectForKey("NodePath") as String
}
