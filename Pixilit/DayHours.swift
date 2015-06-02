//
//  DayHours.swift
//  Pixilit
//
//  Created by SPT Pixilit on 6/2/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

public class DayHours: NSObject, IRestful
{
    var DayOfWeek : [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    
    private(set) var Day: String?
    private(set) var Start: String?
    private(set) var End: String?
    
    override init() { }
    
    required public init(json: JSON) {
        super.init()
        if let day = json["day"].string {
            self.Day = DayOfWeek[day.toInt()!]
        }
        
        if let startTime = json["starthours"].string {
            var start : Int = startTime.toInt()!
            self.Start =  self.ConvertTime (start)
        }
        
        if let endTime = json["endhours"].string {
            var end : Int = endTime.toInt()!
            self.End =  self.ConvertTime (end)
        }
    }
    
    func ConvertTime(time: Int) -> String
    {
        var temp: String!
     
        if (time < 100)
        {
            var tmpMins = time
            var mins = tmpMins == 0 ? "00" : "\(tmpMins)"
            temp = "12:\(mins) AM"
        }
        else if (time < 1200) //in the am
        {
            var tmpMins = time % 100
            var mins = tmpMins == 0 ? "00" : "\(tmpMins)"
            temp = "0\(time / 100):\(mins) AM"
        }
        else if (time > 1200) // after noon
        {
            var tmpMins = (time - 1200) % 100
            var mins = tmpMins == 0 ? "00" : "\(tmpMins)"
            
            if time < 2200 {
                temp = "0\((time - 1200)/100):\(mins) PM"
            } else {
                temp = "\((time - 1200)/100):\(mins) PM"
            }
        }
        else // noon
        {
            var tmpMins = time % 100
            var mins = tmpMins == 0 ? "00" : "\(tmpMins)"
            temp = "\(time / 100):\(time % 100) PM"
        }

        return temp
    }
}
