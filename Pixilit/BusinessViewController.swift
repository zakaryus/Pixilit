//
//  BusinessViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 2/2/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {
    
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
    
    var mintyForest = UIColor.clearColor()//(red: 228, green: 247, blue: 242, alpha: 1)
    var business: Business = Business()
    var tiles:[(tile: Tile, photo: UIImage, photoSize: CGSize, hasImage: Bool)]=[]
    var selectedTile: Tile = Tile()
    let reuseId = "tileCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var refresh = UIRefreshControl()
    var selectedIndex = NSIndexPath()
    @IBAction func shareButton(sender: AnyObject)
    {
        let businessUrl = HelperURLs.UidToUserUrl(business.Uid!)
        let firstActivityItem = "Look what I found in Pixilit! " + businessUrl
        var array: [AnyObject] = [AnyObject]()
        array.append(firstActivityItem)
        //array.append(businessUrl!)
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: array, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    //****************************
    //let reuseId = "businessPhotoCollectionViewCell"
    //let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
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
    
    override public func viewWillAppear(animated: Bool) {
        Setup()
    }
    
    func Setup() {
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
        Refresh()
        
        
    }
    
    func Refresh() {
        HelperREST.RestBusinessTiles(business.Uid!) {
            Tiles in
            
            println(Tiles.count)
            self.tiles = []
            
            for tile in Tiles {
                self.tiles.append(tile: tile, photo: UIImage(), photoSize: CGSizeMake(0, 0), hasImage: false)
            }
            
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
        }
        
    }
    //****************************
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tiles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! TileCollectionViewCell
        
        if !tiles[indexPath.row].hasImage {
            HelperURLs.UrlToImage(tiles[indexPath.row].tile.Photo!) {
                Photo in
                self.tiles[indexPath.row].photo = Photo
                self.tiles[indexPath.row].hasImage = true
            }
        }
        
        cell.setup(self.tiles[indexPath.row].tile, img: self.tiles[indexPath.row].photo)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var size = tiles[indexPath.row].photoSize
        if size == CGSize(width: 0, height: 0) {
            tiles[indexPath.row].photoSize = HelperTransformations.Scale(.HalfScreen, itemToScale: tiles[indexPath.row].tile.PhotoMetadata!, containerWidth: self.view.frame.width)
            var ps = tiles[indexPath.row].photoSize
            println("Business View width: \(ps.width), height: \(ps.height)")
            
        }
        
        return tiles[indexPath.row].photoSize
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    //****************************
    
    func SetBusinessToVC(business: Business)
    {
        if let title = business.Title {
            self.businessName.text = title
            self.businessName.backgroundColor = mintyForest
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
            self.businessLocalityAdminZip.backgroundColor = mintyForest
        }
        
        if let phone = business.Phone {
            self.businessPhone.text = phone
            self.businessPhone.backgroundColor = mintyForest
        }
        
        if let email = business.Email {
            self.businessEmail.text = email
            self.businessEmail.backgroundColor = mintyForest
        }
        
        if let website = business.Website {
            self.businessWebsite.text = website
            self.businessWebsite.backgroundColor = mintyForest
        }
        
        //self.Hours = [String]()
        
        if let description = business.Description {
            self.businessDescription.text = description
            self.businessDescription.backgroundColor = self.mintyForest
        }
        
        if let logo = business.Logo {
            HelperURLs.UrlToImage(logo)
            {
                Image in
                self.businessLogo.image = Image
                self.businessLogo.backgroundColor = self.mintyForest
            }
        }
        
        SetMintyForestBackground()
    }
    
    func SetMintyForestBackground()
    {
        self.businessName.backgroundColor = mintyForest
        businessThoroughfare.backgroundColor = mintyForest
        businessLocalityAdminZip.backgroundColor = mintyForest
        businessPhone.backgroundColor = mintyForest
        businessEmail.backgroundColor = mintyForest
        businessWebsite.backgroundColor = mintyForest
        businessDescription.backgroundColor = mintyForest
        businessLogo.backgroundColor = mintyForest
    }
}
