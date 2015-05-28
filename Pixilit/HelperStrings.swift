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
    
    static func RestNodeJsonString(uid: String, description: String, fid: String, regions: [String], tags: [String]) -> String {
        
        var regionStr = RestArrayJsonString("field_tile_regions", array: regions)
        var tagStr = RestArrayJsonString("field_tags", array: tags)

        
        var rtn = "{\"type\" : \"tile\",\"title\" : \"\(uid)\",\"language\" : \"und\",\(regionStr)\(tagStr)\"field_description\": {\"und\": [{\"value\": \"\(description)\"}]},\"field_image\": {\"und\": [{\"fid\": \(fid.toInt()!)}]}}"
        println(rtn)
        return rtn
    }
    
    private static func RestArrayJsonString(field: String, array: [String]) -> String {
        var arrStr = "\"\(field)\": {\"und\": ["
        var first: Bool = true
        for a in array {
            if(first) {
                arrStr += "\"\(a)\""
                first = false
            } else {
                arrStr += ",\"\(a)\""
            }
        }
        arrStr += "]},"
        
        return arrStr
    }
    
    static func RestUpdateFlagString(nid: String, uid: String, flagged: String) -> String {
        return "{\"flag_name\":\"pixd\",\"entity_id\":\"\(nid)\",\"uid\":\"\(uid)\",\"action\":\"\(flagged)\"}"
    }
}
