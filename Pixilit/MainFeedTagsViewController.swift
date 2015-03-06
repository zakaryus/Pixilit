//
//  MainFeedTagsViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/6/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//http://stackoverflow.com/questions/26670930/uisplitviewcontroller-in-portrait-on-iphone-always-show-master-and-detail-in-ios

import UIKit

class MainFeedTagsViewController: UIViewController
{

        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplitVC()
    }
    
    
    private func configureSplitVC() {
        
        let splitVC = self.childViewControllers[0] as UISplitViewController
        setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: .Regular), forChildViewController: splitVC)
    }
}
