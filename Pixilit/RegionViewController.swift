//
//  RegionViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation
import UIKit

class RegionViewController : UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tvParentRegions: UITableView!
    var Parents: [RegionKvp] = []
    
    var tableVC = UITableViewController(style: .Plain)
    var refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableVC.tableView = tvParentRegions
        tableVC.refreshControl = refresh
        refresh.addTarget(self, action: "RefreshList", forControlEvents: .ValueChanged)
        refresh.beginRefreshing()
        RefreshList()
    }
    
    func RefreshList()
    {
        HelperREST.RestRegionsRequest {
            regions in
            var r = RegionHierarchy(regions: regions)
            
            self.Parents = r.Heirarchy
            
            dispatch_async(dispatch_get_main_queue(),
                {
                    self.tvParentRegions.reloadData()
                    self.refresh.endRefreshing()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = Parents[indexPath.row].Parent.Name
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var srvc = segue.destinationViewController as! SubRegionViewController
        srvc.region = sender as! [Region]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("\(indexPath.row) tapped")
        var region: [Region] = Parents[indexPath.row].Children
        self.performSegueWithIdentifier("SubRegionSegue", sender: region)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Parents.count
    }

}