//
//  RestParameteredQuery.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/21/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

protocol RestParameteredQuery
{
    func Query(BaseString: String, Parameters: Dictionary<String, String>) -> String
}
