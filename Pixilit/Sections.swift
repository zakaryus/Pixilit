//
//  Sections.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 2/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class Sections <T: AnyObject>
{
    let collation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
    var data: [Section<T>] = [Section<T>]()
    
    init(){    }
    
    init(list: [T], key: Selector)
    {
        data = GetData(list, key: key)
    }

    func GetData(list: [T], key: Selector) -> [Section<T>]
    {
        var _sections: [Section<T>]?
        
        // return if already initialized
        if _sections != nil {
            return _sections!
        }
        
        // create empty sections
        var sections = [Section<T>]()
        for i in 0..<collation.sectionIndexTitles.count {
            sections.append(Section())
        }
        
        // assign businesses section variable from a list of businesses
//        var items: [T] = list.map { item in
//            item.section = self.collation.sectionForObject(item, collationStringSelector: key)
//            return item
//        }

        
        // put each user in a section
        for item in list {
            sections[self.collation.sectionForObject(item, collationStringSelector: key)].addItem(item)
        }
        
        // sort each section
        for section in sections {
            section.data = collation.sortedArrayFromArray(section.data, collationStringSelector: key) as [T]
        }
        
        _sections = sections
        
        return _sections!
        
    }
}
