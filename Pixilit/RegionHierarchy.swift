//
//  RegionHierarchy.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation

class RegionHierarchy {
    
    var parents : [parent] = []
    
    struct parent {
        var childRegions : [Region] = []
        var parentRegion : Region
        
        init(region: Region, children : [Region])
        {
            childRegions = children
            parentRegion = region
        }
        func printme()
        {
            println(parentRegion.Name!)
           for child in childRegions
           {
                println(" -- " + child.Name!.capitalizedString)
            }
            
        }
    }
    
    init(regions : [Region])
    {
        var tempParents : [Region] = []
        for region in regions
        {
            if region.PID == 0
            {
                tempParents.append(region)
            }
        }
        
        var dict = Dictionary<Int, [Region]>()
        for parent in tempParents
        {
            var parentsChildren : [Region] = []
            for region in regions
            {
                
                if region.PID == parent.TID
                {
                    parentsChildren.append(region)
                    
                }
            }
            dict[parent.TID!] = parentsChildren
            
        }
        
        
        for par in tempParents
        {
            var p = parent(region: par, children: dict[par.TID!]!)
            parents.append(p)
            
        }
        for parent in parents
        {
            parent.printme()
        }
    }
}