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
    
    //for only one section
    init(list: [T])
    {
        var sections = [Section<T>]()
        sections.append(Section())
        
        for item in list {
            sections[0].addItem(item)
        }
        
        data = sections
    }
    
    //for alphabetical sections
    init(list: [T], key: Selector)
    {
        data = GetStringData(list, key: key)
    }

    func GetStringData(list: [T], key: Selector) -> [Section<T>]
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
    
    
//ATTEMPT AT SORTING BY DATE, NOT EVEN CLOSE AT THE MOMENT
//    func GetDateData(list: [T], key: Selector) -> [Section<T>]
//    {
//        var _sections: [Section<T>]?
//        
//        // return if already initialized
//        if _sections != nil {
//            return _sections!
//        }
//        
//        // create empty sections
//        var sections = [Section<T>]()
//
//        for item in list
//        {
//            // Reduce event start date to date components (year, month, day)
//            let parts =
//            var dateRepresentingThisDay = NSDate.
//            
//            // If we don't yet have an array to hold the events for this day, create one
//            NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
//            if (eventsOnThisDay == nil) {
//                eventsOnThisDay = [NSMutableArray array];
//                
//                // Use the reduced date as dictionary key to later retrieve the event list this day
//                [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
//            }
//            
//            // Add the event to the list for this day
//            [eventsOnThisDay addObject:event];
//        }
//        
//        // Create a sorted list of days
//        NSArray *unsortedDays = [self.sections allKeys];
//        self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
//        
//        
//        
//        
//        
//        // put each user in a section
//        for item in list {
//            sections[self.collation.sectionForObject(item, collationStringSelector: key)].addItem(item)
//        }
//        
//        // sort each section
//        for section in sections {
//            section.data = collation.sortedArrayFromArray(section.data, collationStringSelector: key) as [T]
//        }
//        
//        _sections = sections
//        
//        return _sections!
//    }
}
