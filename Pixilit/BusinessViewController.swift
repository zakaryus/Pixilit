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
        
        self.businessName.text = business.Title
        self.businessNavBar.title = business.Title
        
        //self.businessThoroughfare.text = business.Thoroughfare
        //var locality = business.Locality
        //var aa = business.AdministrativeArea
        //var post = business.PostalCode
        //self.businessLocalityAdminZip.text = "\(locality), \(aa) \(post)"
        //self.businessPhone.text = business.Phone
        //self.businessEmail.text = business.Email
        //self.businessWebsite.text = business.Website
        
        //hours
        
        //self.businessDescription.text = business.Description
        self.businessLogo.image = Helper.UrlToImage(business.Logo)
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
        
        cell.photo.image = Helper.UrlToImage(business.Photos[indexPath.row].Url)
        cell.desc.text = business.Photos[indexPath.row].Description
        
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
}
