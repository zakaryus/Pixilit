//
//  UserViewController.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDelegate {
    
 

    @IBOutlet var colletionView: UICollectionView!
    @IBOutlet weak var usernameField: UITextField!
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
    
        func collectionView(collectionView: UICollectionView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
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
                   // var detailText = json["field_phone_number"]["und"][0]["number"].string
                    
                   // cellToUpdate.textLabel?.text = text
                      self.setName(text!) //update username
                 //   cellToUpdate.detailTextLabel?.text = detailText
                    
               //     var uri = json["field_logo"]["und"][0]["uri"].string
                  var imgPath = json["picture"]["url"].string
               let imgUrl = NSURL(string: imgPath!)
                  let imgData = NSData(contentsOfURL: imgUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check
              //cellToUpdate.imageView.image = UIImage(data: imgData!)
                    cell.imageView.image = UIImage(data: imgData!)
                    // println("text = \(text), detailText = \(detailText), imagePath = \(imgPath)")
                  
                }
            })
        })
        task.resume()
      
        return cell
    }

      func setName(username: String) {
        usernameField.text=username
    }	
    func collectionView(collectionView: UICollectionView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("businessViewController") as BusinessViewController
        viewController.name = String(indexPath.row)
        self.presentViewController(viewController, animated: true, completion: nil)
    }

}

