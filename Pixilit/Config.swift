//
//  Config.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

private let dict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!)

struct Config
{
    static let RestBusinessTileJson: String = dict?.objectForKey("RestBusinessTileJson") as! String
    static let RestBusinessesJson: String = dict?.objectForKey("RestBusinessesJson") as! String
    static let ContentTypeBusiness: String = dict?.objectForKey("ContentTypeBusiness") as! String
    static let FilePathPublicPlaceholder: String = dict?.objectForKey("FilePathPublicPlaceholder") as! String
    static let FilePathPublicValue: String = dict?.objectForKey("FilePathPublicValue") as! String
    static let AppTitle: String = dict?.objectForKey("AppTitle") as! String
    static let NodePath: String = dict?.objectForKey("NodePath") as! String
    static let UserPath: String = dict?.objectForKey("UserPath") as! String
    static let RestMainNewsPageJson: String = dict?.objectForKey("RestMainNewsPageJson") as! String
    static let RestMainFeedJson: String = dict?.objectForKey("RestMainFeedJson") as! String
    static let UserFlagsJson: String = dict?.objectForKey("UserFlagsJson") as! String
    static let RestUserLogin: String = dict?.objectForKey("RestUserLogin") as! String
    static let UserRegistrationURL: String = dict?.objectForKey("UserRegistrationURL") as! String
    static let BusinessRegistrationURL: String = dict?.objectForKey("BusinessRegistrationURL") as! String
    static let RestRegionsJson: String = dict?.objectForKey("RestRegionsJson") as! String
    static let RestBusinessJson: String = dict?.objectForKey("RestBusinessJson") as! String
}
