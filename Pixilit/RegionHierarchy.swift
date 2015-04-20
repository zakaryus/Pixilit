//
//  RegionHierarchy.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation

class RegionHierarchy {
    
    private(set) var Heirarchy : [RegionKvp] = []
    
    init(regions : [Region])
    {
        var tempParents : [Region] = []
        for region in regions
        {
            if region.PID == 0
            {
                Heirarchy.append(RegionKvp(parent: region))
            }
        }
        
        for item in Heirarchy
        {
            for region in regions
            {
                if region.PID == item.Parent.TID
                {
                    item.AddChild(region)
                }
            }
        }
                
//        for parent in Heirarchy
//        {
//            parent.printme()
//        }
    }
}