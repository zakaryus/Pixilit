
//  BusinessListViewController.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.


import UIKit

class BusinessListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate
{
    //var collation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listOfBusinesses: [Business] = [Business]()
    var filteredListOfBusinesses: [Business] = [Business]()
    var sections: Sections<Business> = Sections<Business>()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         //Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        Helper.RestContentTypeRequest(Config.ContentTypeBusiness)
        {
            urls in
            
            Helper.RestUrlToContent(urls)
            {
                Items in
                self.listOfBusinesses = Items
                
                self.sections = Sections<Business>(list: self.listOfBusinesses, key: "Title")
                
                self.tableView.reloadData()
            }
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
        
        var b: Business = self.sections.data[indexPath.section].data[indexPath.row]
        
        cell.textLabel?.text = b.Title
        cell.detailTextLabel?.text = b.Phone
        cell.imageView?.image = Helper.UrlToImage(b.Logo)
        
        return cell
    }
   
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var b: Business = self.sections.data[indexPath.section].data[indexPath.row] as Business
        self.performSegueWithIdentifier("BusinessShowSegue", sender: b)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var bvc = segue.destinationViewController as BusinessViewController
        bvc.business = sender as Business
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
                return UILocalizedIndexedCollation.currentCollation().sectionTitles[section] as String
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
            let stringMatch = business.Title.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil
        })
        
        self.sections = Sections<Business>(list: self.filteredListOfBusinesses, key: "Title")
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool
    {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
}

