//
//  MySplitView.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/6/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class MySplitView: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

}
