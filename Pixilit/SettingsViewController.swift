//
//  SettingsViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 3/31/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UITextViewDelegate
{

    @IBOutlet var tvSettings: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        if User.Role == AccountType.Business {
            ToggleRowVisibility(false, photo: true, payment: true, logout: true)
        }
        else if User.Role == AccountType.User || User.Role == AccountType.Admin {
            ToggleRowVisibility(true, photo: false, payment: false, logout: true)
        }
        else if User.Role == AccountType.Anonymous {
            ToggleRowVisibility(false, photo: false, payment: false, logout: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvSettings.delegate = self
    }
    
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
            performSegueWithIdentifier("SavedRegionSegue", sender: self)
        }
        else if indexPath.row == Section1.AccountInfo.rawValue && indexPath.section == 0 {
            println("Account info")
            performSegueWithIdentifier("AccountInfoSegue", sender: self)
        }
        else if indexPath.row == Section1.Payment.rawValue && indexPath.section == 0 {
            println("Payment")
            performSegueWithIdentifier("PaymentSegue", sender: self)
        }
        else if indexPath.row == Section2.About.rawValue && indexPath.section == 1 {
            println("About")
            performSegueWithIdentifier("AboutSegue", sender: self)
        }
        else if indexPath.row == Section2.Logout.rawValue && indexPath.section == 1 {
            
            User.Logout()
            if let tbc = self.tabBarController {
                tbc.selectedIndex = 0
            }

            
           
        }
    }

    func ToggleRowVisibility(region: Bool, photo: Bool, payment: Bool, logout: Bool)
    {
         tvSettings.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!.hidden = !region
         tvSettings.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))!.hidden = !photo
         tvSettings.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))!.hidden = !payment
         tvSettings.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))!.hidden = !logout
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var segueName = segue.identifier
        
        if segueName == "SavedRegionSegue"
        {
            var a = segue.destinationViewController as! SavedRegionViewController
        }
        else if segueName == "AccountInfoSegue"
        {
            var a = segue.destinationViewController as! AccountInfoViewController
        }
        else if segueName == "PaymentSegue"
        {
            var a = segue.destinationViewController as! PaymentViewController
        }
        else if segueName == "AboutSegue"
        {
            var a = segue.destinationViewController as! AboutViewController
        }
       
        
    }
    
   
    
  
    
}