//
//  AboutViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/13/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController : UIViewController
{
    var a : Int = 0
    
    
   override func viewDidLoad() {
        if a == 1 {
            var a = RegionsViewHandler ()
            self.view.addSubview(a)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
       // Setup()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
}
