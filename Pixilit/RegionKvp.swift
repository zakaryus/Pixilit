//
//  RegionKvp.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/15/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

class RegionKvp {

    private(set) var Parent : Region
    private(set) var Children : [Region]
    
    init(parent: Region)
    {
        Parent = parent
        Children = []
    }
    
    init(parent: Region, children : [Region])
    {
        Parent = parent
        Children = children
    }
    
    func AddChild(child: Region)
    {
        Children.append(child)
    }
    
    func printme()
    {
        //println(Parent.Name!)
        for child in Children
        {
            //println(" -- " + child.Name!.capitalizedString)
        }
        
    }
}
