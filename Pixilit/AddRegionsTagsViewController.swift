//
//  AddRegionTagsViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 5/22/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class AddRegionsTagsViewController: UploadPhotoViewController, UITextViewDelegate, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource {


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var TblRegions: UITableView!
    @IBOutlet weak var TbDescription: UITextView!
    @IBOutlet weak var BtnDone: UIButton!
    @IBOutlet weak var TblTags: UITableView!
    var delegate: writeValueBackDelegate?
    var refresh = UIRefreshControl()
    var tableVC = UITableViewController(style: .Plain)
    var addRegions: [String] = []
    var clsTags : [Tag] = []
    var addTags: [String] = []
    var allTags : [Tag] = []
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = HelperTransformations.BackgroundColor()
        
        var dismiss =  UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        dismiss.numberOfTapsRequired = 1
        dismiss.cancelsTouchesInView = false
        self.view.addGestureRecognizer(dismiss)
        
        tableVC.tableView = TblTags
        tableVC.refreshControl = refresh
        refresh.addTarget(self, action: "RefreshList", forControlEvents: .ValueChanged)
     
        RefreshList()

        TblRegions.reloadData()

        self.BtnDone.enabled = false
        self.TbDescription.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func RefreshList()
    {
        refresh.beginRefreshing()
        HelperREST.RestTagsRequest {
            Tags in
            
            self.clsTags = Tags
            self.allTags = Tags
            self.TblTags.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer!) {
        searchBar.resignFirstResponder()
        TbDescription.resignFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func CancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func BtnDoneClick(sender: AnyObject) {
        
        delegate?.writeValueBack(TbDescription.text, regions: addRegions, tags: addTags)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        checkForDone()
    }
    
    func checkForDone() {
        if !TbDescription.text.isEmpty && TbDescription.textColor != UIColor.lightGrayColor() && !addRegions.isEmpty && !addTags.isEmpty
        {
            self.BtnDone.enabled = true
        }
        else {
            self.BtnDone.enabled = false
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == TblRegions {
            return User.Regions.count
        }
        else {  //TblTags and SearchDisplay
            return clsTags.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var reId : String = ""
        var value : String = ""
        var check : Bool = false
        if tableView == TblRegions {
            reId = "RegionCell"
            value = User.Regions[indexPath.row].Name!.capitalizedString
            check = contains(addRegions, "\(User.Regions[indexPath.row].TID!)")
        }
        else {
            reId = "TagCell"
            value = clsTags[indexPath.row].Name!.capitalizedString
            check = contains(addTags, "\(clsTags[indexPath.row].TID!)")
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reId)
        cell.textLabel?.text = value
        cell.accessoryType = check ? .Checkmark : .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        
        if tableView == TblRegions {
            if cell?.accessoryType == .Checkmark {
                cell?.accessoryType = .None
                addRegions = addRegions.filter() { $0 != "\(User.Regions[indexPath.row].TID!)" }
            }
            else {
                cell?.accessoryType = .Checkmark
                addRegions.append("\(User.Regions[indexPath.row].TID!)")
            }
            checkForDone()
        }
        else {
            if cell?.accessoryType == .Checkmark {
                cell?.accessoryType = .None
                addTags = addTags.filter() { $0 != "\(self.clsTags[indexPath.row].TID!)" }
            }
            else {
                cell?.accessoryType = .Checkmark
                addTags.append("\(clsTags[indexPath.row].TID!)")
            }
            checkForDone()
        }
    }
    
    func filterContentForSearchText(searchText: String)
    {
        // Filter the array using the filter method
        self.clsTags = self.allTags.filter({(tag: Tag) -> Bool in
            if let name = tag.Name {
                let stringMatch = name.lowercaseString.rangeOfString(searchText.lowercaseString)
                return stringMatch != nil
            }
            return false
        })
        
        println(self.clsTags.count)
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        if searchString == "" {
            self.clsTags = self.allTags
            self.TblTags.reloadData()
        } else {
            self.filterContentForSearchText(searchString)
            self.TblTags.reloadData()
        }
        
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool
    {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
}
