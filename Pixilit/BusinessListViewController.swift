
//  BusinessListViewController.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.


import UIKit

class BusinessListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate
{    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listOfBusinesses: [Business] = [Business]()
    var filteredListOfBusinesses: [Business] = [Business]()
    var sections: Sections<Business> = Sections<Business>()
    
    var tableVC = UITableViewController(style: .Plain)
    var refresh = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         //Do any additional setup after loading the view, typically from a nib.
        
        tableVC.tableView = tableView
        tableVC.refreshControl = refresh
        refresh.addTarget(self, action: "RefreshList", forControlEvents: .ValueChanged)
        refresh.beginRefreshing()
        RefreshList()
    }
    
    func RefreshList()
    {
        HelperREST.RestBusinessesRequest
        {
                bus in
                
                ////println(bus.count)
                
                self.listOfBusinesses = bus
                self.sections = Sections<Business>(list: self.listOfBusinesses, key: "Title")
                
                dispatch_async(dispatch_get_main_queue(),
                {
                        self.tableView.reloadData()
                        self.refresh.endRefreshing()
                })
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
         //Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        var business: Business = self.sections.data[indexPath.section].data[indexPath.row]
        
        if let logo = business.Logo {
            HelperURLs.UrlToImage(logo)
            {
                Image in
                
                cell.imageView?.image = Image
                
                if let title = business.Title {
                    cell.textLabel?.text = title
                }
                
                if let phone = business.Phone {
                    cell.detailTextLabel?.text = phone
                }

            }
        }
        
        return cell
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var b: Business = self.sections.data[indexPath.section].data[indexPath.row] as Business
        self.performSegueWithIdentifier("BusinessShowSegue", sender: b)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var bvc = segue.destinationViewController as! BusinessViewController
        bvc.business = sender as! Business
    }
    
    /**************************************************************************************/
    
    //adapted from tutorial at http://www.pumpmybicep.com/2014/07/04/uitableview-sectioning-and-indexing/
    // table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
                return self.sections.data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return self.sections.data[section].data.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String
    {
            // do not display empty `Section`s
            if !self.sections.data[section].data.isEmpty {
                return UILocalizedIndexedCollation.currentCollation().sectionTitles[section] as! String
            }
            return ""
    }

    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]
    {
        return UILocalizedIndexedCollation.currentCollation().sectionIndexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
    }
    
    /**************************************************************************************/
    
    func filterContentForSearchText(searchText: String)
    {
        // Filter the array using the filter method
        self.filteredListOfBusinesses = self.listOfBusinesses.filter({( business: Business) -> Bool in
            if let title = business.Title {
                let stringMatch = title.lowercaseString.rangeOfString(searchText.lowercaseString)
                return stringMatch != nil
            }
            return false
        })
        
        self.sections = Sections<Business>(list: self.filteredListOfBusinesses, key: "Title")
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool
    {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
}

