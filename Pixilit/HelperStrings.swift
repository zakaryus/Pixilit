//
//  HelperStrings.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/13/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

struct HelperStrings
{
    //STRINGIFY
    //From: http://apexappdev.com/date-to-month-day-year-in-swift/
    static func NSDateToString(date: NSDate) -> String {
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        
        return "\(month)/\(day)/\(year)"
    }
    
    static func RestFileJsonString(base64 : String) -> String {
        return "{\"file\":{\"file\": \"\(base64)\",\"filename\":\"my_first_image.png\",\"uri\":\"public://my_first_image.png\"}}"
    }
    
    static func RestNodeJsonString(uid: String, description: String, fid: String) -> String {
        return "{\"type\" : \"tile\",\"title\" : \"\(uid)\",\"language\" : \"und\",\"field_description\": {\"und\": [{\"value\": \"\(description)\"}]},\"field_image\": {\"und\": [{\"fid\": \(fid.toInt()!)}]}}"
    }
}
