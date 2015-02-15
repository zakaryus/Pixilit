//
//  ContentType.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

protocol ContentType
{
    init()
    class func Create(Url: String, CompletionHandler: (Item: ContentType) -> ())
}
