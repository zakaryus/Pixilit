//
//  UserViewController.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDelegate {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    @IBOutlet var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.registerClass(CustomCell.self, forCellWithReuseIdentifier: "ImgCell")
        //Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImgCell", forIndexPath: indexPath) as CustomCell
        
        let urlPath = "http:www.pixilit.com/rest/user/19.json"
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath)  {
                    
                    var json = JSON(data: data)
                    println(json)
                    var text = json["name"].string
                    
                    self.setName(text!) //update username
                    
                    var imgPath = json["picture"]["url"].string
                    let imgUrl = NSURL(string: imgPath!)
                    let imgData = NSData(contentsOfURL: imgUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    cell.imageView.image = UIImage(data: imgData!)
                    
                }
            })
        })
        task.resume()
        
        return cell
    }
    
    func setName(username: String) {
        usernameField.text=username
    }

    
}

