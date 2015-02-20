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
    
    var business: Business = Business()
    
    @IBAction func shareButton(sender: AnyObject)
    {
        let firstActivityItem = "Look what I found in Pixilit!"
        let businessUrl = business.PixilitURL
        var array: [AnyObject] = [AnyObject]()
        array.append(firstActivityItem)
        array.append(businessUrl!)
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: array, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
        SetBusinessToVC(business)
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
        return self.business.Photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: BusinessPhotoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as BusinessPhotoCollectionViewCell
        
        if let url = business.Photos[indexPath.row].Url {
            
            Helper.UrlToImage(url)
            {
                Image in
                cell.photo.image = Image
                
                if let description = self.business.Photos[indexPath.row].Description {
                    cell.desc.text = description
                }
            }
        }
        
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
    
    func SetBusinessToVC(business: Business)
    {
        if let title = business.Title {
            self.businessName.text = title
            self.businessNavBar.title = title
        }
        
        var thoroughfare: String
        if let _thoroughfare = business.Thoroughfare {
            thoroughfare = _thoroughfare
        }
        
        var locality: String = ""
        if let _locality = business.Locality {
            locality = _locality
        }
        
        var administrativearea: String = ""
        if let _administrativearea = business.AdministrativeArea {
            administrativearea = _administrativearea
        }
        
        var postalcode: String = ""
        if let _postalcode = business.PostalCode {
            postalcode = _postalcode
        }
        
        if locality != "" && administrativearea != "" && postalcode != "" {
            self.businessLocalityAdminZip.text = "\(locality), \(administrativearea) \(postalcode)"
        }
        
        if let phone = business.Phone {
            self.businessPhone.text = phone
        }
        
        if let email = business.Email {
            self.businessEmail.text = email
        }
        
        if let website = business.Website {
            self.businessWebsite.text = website
        }
        
        //self.Hours = [String]()
        
        if let description = business.Description {
            self.businessDescription.text = description
        }
        
        if let logo = business.Logo {
            Helper.UrlToImage(logo)
            {
                Image in
                self.businessLogo.image = Image
            }
        }
    }
}
