//
//  FirstViewController.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UITableViewDelegate {
    
    var cellText:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        
        let urlPath = "http://www.pixilit.com/rest/node/\(indexPath.row + 1).json"
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    
                    var json = JSON(data: data)
                    var text = json["title"].string
                    var detailText = json["field_phone_number"]["und"][0]["number"].string
                    
                    println("text = \(text), detailText = \(detailText)")
                    
                    cellToUpdate.textLabel?.text = text
                    cellToUpdate.detailTextLabel?.text = detailText
                    
                }
            })
        })
        task.resume()
        
        return cell
    }
}

