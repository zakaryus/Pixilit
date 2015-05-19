//
//  Section.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

// custom type to represent table sections
class Section<T: AnyObject>
{
    var data: [T] = []
    
    func addItem(item: T) {
        self.data.append(item)
    }
}