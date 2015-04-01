//
//  SettingsViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 3/31/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{

    @IBAction func showAboutPage(sender: AnyObject) {
    }

    @IBAction func logout(sender: AnyObject) {
        User.SetAnonymous()
    }
    
}