
//  BusinessListViewController.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.


import UIKit

class BusinessListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var collation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    class Business: NSObject {
        let Title: String
        let Url: String
        var section: Int?
        
        init(Title: String, Url: String) {
            self.Title = Title
            self.Url = Url
        }
    }
    
    // custom type to represent table sections
    class Section {
        var businesses: [Business] = []
        
        func addBusiness(business: Business) {
            self.businesses.append(business)
        }
    }
    
    var listOfBusinesses: [Business] = [Business]()
    var filteredListOfBusinesses = [Business]()
    var sections: [Section] = [Section]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         //Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        genericRestRequest() {
            urls in
            self.listOfBusinesses = urls
            
            self.sections = self.getSections(self.listOfBusinesses)
            
            self.tableView.reloadData()
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
        
        var urlPath = self.sections[indexPath.section].businesses[indexPath.row].Url

        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                 //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    
                    var json = JSON(data: data)
                    //println(json)

                    var text = json["title"].string
                    var detailText = json["field_phone_number"]["und"][0]["number"].string
                    
                    cellToUpdate.textLabel?.text = text
                    cellToUpdate.detailTextLabel?.text = detailText
                    
                    var uri = json["field_logo"]["und"][0]["uri"].string
                    var imgPath = uri?.stringByReplacingOccurrencesOfString("public:", withString: "http://www.pixilit.com/sites/default/files/")
                    let imgUrl = NSURL(string: imgPath!)
                    let imgData = NSData(contentsOfURL: imgUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    cellToUpdate.imageView?.image = UIImage(data: imgData!)
                }
            })
        })
        task.resume()
        
        return cell
    }
   
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var nid = self.sections[indexPath.section].businesses[indexPath.row].Url
        self.performSegueWithIdentifier("BusinessShowSegue", sender: nid)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var bvc = segue.destinationViewController as BusinessViewController
        bvc.nid = sender as String
    }
    
    func genericRestRequest(completionHandler: (urls: [Business]) -> ())
    {
        var tmpUrls = [Business]()

        let urlPath = "http:www.pixilit.com/rest/node.json"
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                var json = JSON(data: data)
                //println(json)
                
                for (index: String, subJson: JSON) in json {
                    
                    //println(subJson)
                    
                    if subJson["type"].string == "business"
                    {
                        var business: Business = Business(Title: subJson["title"].string!, Url: subJson["uri"].string! + ".json")
                        tmpUrls.append(business)
                    }
                }
                
                tmpUrls = tmpUrls.sorted({$0.Title < $1.Title})
                
                completionHandler(urls: tmpUrls)
                
            })
        })
        task.resume()
    }
    
    /**************************************************************************************/
    
    //adapted from tutorial at http://www.pumpmybicep.com/2014/07/04/uitableview-sectioning-and-indexing/
    // table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
                return self.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return self.sections[section].businesses.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String
    {
            // do not display empty `Section`s
            if !self.sections[section].businesses.isEmpty {
                return self.collation.sectionTitles[section] as String
            }
            return ""
    }

    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]
    {
            return self.collation.sectionIndexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
            return self.collation.sectionForSectionIndexTitleAtIndex(index)
    }
    
    func getSections(list: [Business]) -> [Section]
    {
        var _sections: [Section]?
        
        // return if already initialized
        if _sections != nil {
            return _sections!
        }
        
        // assign businesses section variable from a list of businesses
        var businesses: [Business] = list.map { business in
            business.section = self.collation.sectionForObject(business, collationStringSelector: "Title")
            return business
        }
        
        // create empty sections
        var sections = [Section]()
        for i in 0..<collation.sectionIndexTitles.count {
            sections.append(Section())
        }
        
        // put each user in a section
        for business in businesses {
            sections[business.section!].addBusiness(business)
        }
        
        // sort each section
        for section in sections {
            section.businesses = collation.sortedArrayFromArray(section.businesses, collationStringSelector: "Title") as [Business]
        }
        
        _sections = sections
        
        return _sections!
        
    }
    
    /**************************************************************************************/
    
    func filterContentForSearchText(searchText: String)
    {
        // Filter the array using the filter method
        self.filteredListOfBusinesses = self.listOfBusinesses.filter({( business: Business) -> Bool in
            let stringMatch = business.Title.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil
        })
        
        self.sections = self.getSections(self.filteredListOfBusinesses)
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

