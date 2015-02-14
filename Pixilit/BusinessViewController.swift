//
//  BusinessViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 2/2/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var businessNavBar: UINavigationItem!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessThoroughfare: UILabel!
    @IBOutlet weak var businessLocalityAdminZip: UILabel!
    @IBOutlet weak var businessPhone: UILabel!
    @IBOutlet weak var businessEmail: UILabel!
    @IBOutlet weak var businessWebsite: UILabel!
    @IBOutlet weak var businessDescription: UILabel!
    @IBOutlet weak var businessLogo: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    var RestBusinessUrl: String = ""
    
    class collectionCell: NSObject {
        let PhotoUrl: String
        let Desc: String
        var section: Int?
        
        init(PhotoUrl: String, Desc: String) {
            self.PhotoUrl = PhotoUrl
            self.Desc = Desc
        }
    }
    
    //****************************
    let reuseId = "businessPhotoCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var cells: [collectionCell] = [collectionCell]()
    //****************************


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView!.registerClass(BusinessPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        genericRestRequest() {
            photos in
            self.cells = photos
            
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    }
    
    //****************************
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.cells.count
        //return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: BusinessPhotoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as BusinessPhotoCollectionViewCell
        
        var urlPath = RestBusinessUrl
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) as? BusinessPhotoCollectionViewCell {

                    cellToUpdate.photo.image = Helper.UrlToImage(self.cells[indexPath.row].PhotoUrl)
                    cellToUpdate.desc.text = self.cells[indexPath.row].Desc
                    
                    var json = JSON(data: data)

                    var uri = json["field_photos"]["und"][indexPath.row]["uri"].string
                    var url = uri?.stringByReplacingOccurrencesOfString(Config.FilePathPublicPlaceholder, withString: Config.FilePathPublicValue)
                    
                    var desc = json["field_photos"]["und"][indexPath.row]["title"].string
                    
                    cellToUpdate.photo.image = Helper.UrlToImage(url!)
                    cellToUpdate.desc.text = desc

                }
            })
        })
        task.resume()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            return CGSize(width: 198, height: 288)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    //****************************
    
    
    func genericRestRequest(completionHandler: (photos: [collectionCell]) -> ())
    {
        var tmpPhotos = [collectionCell]()
        
        let urlPath = RestBusinessUrl
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                //If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                var json = JSON(data: data)
                self.businessName.text = json["title"].string
                self.businessNavBar.title = json["title"].string
                
                self.businessThoroughfare.text = json["field_address"]["und"][0]["thoroughfare"].string!
                var locality = json["field_address"]["und"][0]["locality"].string!
                var aa = json["field_address"]["und"][0]["administrative_area"].string!
                var post = json["field_address"]["und"][0]["postal_code"].string!
                self.businessLocalityAdminZip.text = "\(locality), \(aa) \(post)"
                self.businessPhone.text = json["field_phone_number"]["und"][0]["value"].string
                self.businessEmail.text = json["field_email"]["und"][0]["email"].string
                self.businessWebsite.text = json["field_website"]["und"][0]["url"].string
                
                //hours
                
                self.businessDescription.text = json["field_description"]["und"][0]["value"].string
                self.businessLogo.image = Helper.UrlToImage(json["field_logo"]["und"][0]["uri"].string!)
                
                //store photo urls in cellPhotos array
                
                if let photos = json["field_photos"]["und"].array
                {
                    for p in photos {
                        var uri = p["uri"].string
                        var url = uri?.stringByReplacingOccurrencesOfString(Config.FilePathPublicPlaceholder, withString: Config.FilePathPublicValue)
                        var c: collectionCell = collectionCell(PhotoUrl: url!, Desc: p["title"].string!)
                        
                        tmpPhotos.append(c)
                    }
                }
                
                completionHandler(photos: tmpPhotos)
            })
        })
        task.resume()
    }


}
