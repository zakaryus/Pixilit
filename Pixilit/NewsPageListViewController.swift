
//  NewsPageListViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/2/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.


import UIKit

class NewsPageListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate
{
    //var collation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listOfNewsPages: [NewsPage] = [NewsPage]()
    var filteredListOfNewsPages: [NewsPage] = [NewsPage]()
    var sections: Sections<NewsPage> = Sections<NewsPage>()
    
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
        HelperREST.RestMainNewsPageRequest()
            {
                newspage in
                
                self.listOfNewsPages = newspage
                self.sections = Sections<NewsPage>(list: self.listOfNewsPages)
                
                dispatch_async(dispatch_get_main_queue(),
                    {
                        println(self.listOfNewsPages)
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
        
        var newspage: NewsPage = self.sections.data[indexPath.section].data[indexPath.row]
        //var newspage: NewsPage = self.listOfNewsPages[indexPath.row]
        
        cell.textLabel?.text = "\(newspage.Title!) \(HelperStrings.NSDateToString(newspage.Date!))"
        cell.detailTextLabel?.text = newspage.Body
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var np: NewsPage = self.sections.data[indexPath.section].data[indexPath.row] as NewsPage
        self.performSegueWithIdentifier("NewsPageShowSegue", sender: np)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {

        var nvc: NewsPageViewController = segue.destinationViewController as NewsPageViewController
        nvc.newspage = sender as NewsPage
    }
    
    /**************************************************************************************/
    
    //adapted from tutorial at http:www.pumpmybicep.com/2014/07/04/uitableview-sectioning-and-indexing/
    //table view data source*
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return self.sections.data.count
        //return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.sections.data[section].data.count
        //return self.listOfNewsPages.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String
    {
        // do not display empty `Section`s
//        if !self.sections.data[section].data.isEmpty {
//            return UILocalizedIndexedCollation.currentCollation().sectionTitles[section] as String
//        }
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
        self.filteredListOfNewsPages = self.listOfNewsPages.filter({(newspage: NewsPage) ->
            
            Bool in
            
            var term: Bool = false
            
            if let title = newspage.Title {
                let stringMatch = title.lowercaseString.rangeOfString(searchText.lowercaseString)
                term = stringMatch != nil
            }
            
            if !term {
                if let body = newspage.Body {
                    let stringMatch = body.lowercaseString.rangeOfString(searchText.lowercaseString)
                    term = stringMatch != nil
                }
            }
            
            if !term {
                if let date = newspage.Date {
                    let stringMatch = HelperStrings.NSDateToString(date).lowercaseString.rangeOfString(searchText.lowercaseString)
                    term = stringMatch != nil
                }
            }
            
            return term
        })
        
        self.sections = Sections<NewsPage>(list: self.filteredListOfNewsPages)
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
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.sections = Sections<NewsPage>(list: self.listOfNewsPages)
        self.tableView.reloadData()
    }

}
