//
//  RegionViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation
import UIKit

class RegionViewController : UIViewController {
    
    override func viewDidLoad() {
        HelperREST.RestRegionsRequest {
            regions in
            var r = RegionHierarchy(regions: regions)
        }
        
    }
}