//
//  File.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/7/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation
import UIKit

class NSewsPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var crypt = MyCrypt()
        var edata: NSData = crypt.encryptString("Hello from swift my little swifty")
        println(edata)
        var pdata: String = crypt.decryptData(edata)
        println(pdata)
    }

}