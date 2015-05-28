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
    static let RestTileTags : String = dict?.objectForKey("RestTileTags") as! String
    static let RestFileCreate : String = dict?.objectForKey("RestFileCreate") as! String
    static let RestNodeCreate : String = dict?.objectForKey("RestNodeCreate") as! String
    static let RestUserLogout : String = dict?.objectForKey("RestUserLogout") as! String
    static let RestSystemConnect : String = dict?.objectForKey("RestSystemConnect") as! String
    static let RestUserToken : String = dict?.objectForKey("RestUserToken") as! String
    static let RestUserProfile : String = dict?.objectForKey("RestUserProfile") as! String
    static let RestIsFlagged : String = dict?.objectForKey("RestIsFlagged") as! String
    static let RestFlagJson: String = dict?.objectForKey("RestFlagJson") as! String
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
    static let RestMainFeedRegionsJson: String = dict?.objectForKey("RestMainFeedRegionsJson") as! String
    static let UserFlagsJson: String = dict?.objectForKey("UserFlagsJson") as! String
    static let RestUserLogin: String = dict?.objectForKey("RestUserLogin") as! String
    static let UserRegistrationURL: String = dict?.objectForKey("UserRegistrationURL") as! String
    static let BusinessRegistrationURL: String = dict?.objectForKey("BusinessRegistrationURL") as! String
    static let RestRegionsJson: String = dict?.objectForKey("RestRegionsJson") as! String
    static let RestBusinessJson: String = dict?.objectForKey("RestBusinessJson") as! String
    static let RestFacebookConnect: String = dict?.objectForKey("RestFacebookConnect") as! String
    static let RestAboutPixilit: String = dict?.objectForKey("RestAboutPixilit") as! String
}
