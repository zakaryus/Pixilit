//
//  CustomSegue.swift
//  Pixilit
//
//  Created by SPT Pixilit on 5/19/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation


class CustomSegue : UIStoryboardSegue
{
  
    
    override func perform() {
        var source : UIViewController = self.sourceViewController as! UIViewController
        var destination : UIViewController = self.destinationViewController as! UIViewController
        
        source.navigationController?.pushViewController(destination, animated: false) 
    }
}