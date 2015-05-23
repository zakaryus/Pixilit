//
//  AddRegionTagsViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 5/22/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class AddRegionsTagsViewController: UploadPhotoViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TblRegions: UITableView!
    @IBOutlet weak var TbDescription: UITextView!
    @IBOutlet weak var BtnDone: UIButton!
    var delegate: writeValueBackDelegate?
    
    var addRegions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BtnDone.enabled = false
        self.TbDescription.delegate = self
        self.TbDescription.text = "Enter Description..."
        self.TbDescription.textColor = UIColor.lightGrayColor()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        TblRegions.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func BtnDoneClick(sender: AnyObject) {
        
        delegate?.writeValueBack(TbDescription.text, regions: addRegions, tags: "Tags")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        if(!textView.text.isEmpty)
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.accessoryType = .Checkmark
        
        addRegions.append("\(User.Regions[indexPath.row].TID!)")
        
    }

}
