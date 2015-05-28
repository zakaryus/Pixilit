//
//  SavedRegionViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/15/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class SavedRegionViewController: UIViewController {

    @IBOutlet weak var savedRegions: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
           self.view.backgroundColor = HelperTransformations.BackgroundColor()
      // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        savedRegions.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.Regions.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
       cell.textLabel?.text = User.Regions[indexPath.row].Name?.capitalizedString
        
        return cell
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            User.RemoveRegion("\(User.Regions[indexPath.row].TID!)")
            savedRegions.reloadData()
        }
    }
    
}
