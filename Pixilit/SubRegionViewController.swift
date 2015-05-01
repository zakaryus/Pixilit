//
//  SubRegionViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/15/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class SubRegionViewController: UIViewController {

    @IBOutlet weak var tvSubRegions: UITableView!
    var regions : [Region] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = regions[indexPath.row].Name?.capitalizedString
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("\(indexPath.row) tapped")
//        var region: [Region] = Parents[indexPath.row].Children
//        self.performSegueWithIdentifier("SubRegionSegue", sender: region)
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell?.accessoryType = UITableViewCellAccessoryType.None
        } else {
            
            if User.AddRegion("\(regions[indexPath.row].TID!)") {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
       
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions.count
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
