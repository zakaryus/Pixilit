//
//  SettingsViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 3/31/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController
{

    @IBOutlet var tvSettings: UITableView!
    
    enum Section1 : Int {
        case Region = 0
        case AccountInfo
        case Payment
    }
    
    enum Section2 : Int {
        case About = 0
        case Logout
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == Section1.Region.rawValue && indexPath.section == 0 {
            println("Region")
            performSegueWithIdentifier("RegionSegue", sender: "region")
        }
        else if indexPath.row == Section1.AccountInfo.rawValue && indexPath.section == 0 {
            println("Account info")
        }
        else if indexPath.row == Section1.Payment.rawValue && indexPath.section == 0 {
            println("Payment")
        }
        else if indexPath.row == Section2.About.rawValue && indexPath.section == 1 {
            println("About")
        }
        else if indexPath.row == Section2.Logout.rawValue && indexPath.section == 1 {
            println("Logged out")
            User.SetAnonymous()
           
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var a = segue.destinationViewController.topViewController as AboutViewController
        a.a = 1
        
    }
    
  
    
}