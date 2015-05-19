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
    
    @IBAction func GoBackPushed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
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
    
    override func viewWillAppear(animated: Bool) {
        Setup()
    }
    
    func Setup() {
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
        Refresh()
        
        
    }
    
    func Refresh() {
        
        //var tmpTiles: [Tile] = []
//        var tmpTile: Tile = Tile()
//        var json = HelperREST.RestRequest(Config.RestBusinessTileJson + business.Uid!, content: nil, method: HelperREST.HTTPMethod.Get, headerValues: nil)
//        if json != nil {
//        for (index: String, subJson: JSON) in json {
//            
//            println(subJson)
//            
//            tmpTile = Tile(json: subJson)
//            tmpTiles.append(tmpTile)
//        }
        HelperREST.RestBusinessTiles(business.Uid!) {
            Tiles in
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
            cell.setup(nil, img: nil)
            
            HelperURLs.UrlToImage(tiles[indexPath.row].tile.Photo!) {
                Photo in
                
                var update = collectionView.cellForItemAtIndexPath(indexPath) as! TileCollectionViewCell?
                if(update != nil) {
                    self.tiles[indexPath.row].photo = Photo
                    self.tiles[indexPath.row].hasImage = true
                    update!.setup(self.tiles[indexPath.row].tile, img: self.tiles[indexPath.row].photo)
                    self.registerTaps(update!)
                    
                }
            }
        }
        else {
            cell.setup(self.tiles[indexPath.row].tile, img: self.tiles[indexPath.row].photo)
            registerTaps(cell)
        }
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
        selectedIndex = indexPath
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
    
    func registerTaps(cell: TileCollectionViewCell) {
        var singleTap = UITapGestureRecognizer(target: self, action: "segueToPopup:")
        singleTap.numberOfTapsRequired = 1
        var doubleTap = UITapGestureRecognizer(target: self, action: "picDoubleTapped:")
        doubleTap.numberOfTapsRequired = 2
        
        cell.addGestureRecognizer(singleTap)
        cell.addGestureRecognizer(doubleTap)
        
        singleTap.requireGestureRecognizerToFail(doubleTap)
    }
    
    func segueToPopup(sender: UITapGestureRecognizer!) {
        self.performSegueWithIdentifier("popupSegue", sender: selectedIndex.row)
    }
    
    func picDoubleTapped(sender: UITapGestureRecognizer!)
    {
        if !User.IsLoggedIn() {
            return
        }
        var flagged = tiles[self.selectedIndex.row].tile.Pixd == false ? "flag" : "unflag"
        var content = "{\"flag_name\":\"pixd\",\"entity_id\":\"\(tiles[selectedIndex.row].tile.Nid!)\",\"uid\":\"\(User.Uid)\",\"action\":\"\(flagged)\"}"
        var success = HelperREST.RestRequest(Config.RestFlagJson, content: content, method: HelperREST.HTTPMethod.Post,  headerValues: [("X-CSRF-Token",User.Token)])
        
        if success[0].stringValue == "true"
        {
            self.tiles[self.selectedIndex.row].tile.Pixd = self.tiles[self.selectedIndex.row].tile.Pixd == true ? false : true
        }
        
        setCellPix()
        //tiles[self.selectedIndex.row].setPixd()
    }
    
    func setCellPix() {
        var cell: TileCollectionViewCell = collectionView.cellForItemAtIndexPath(selectedIndex) as! TileCollectionViewCell
        cell.setPixd()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var tpvc = segue.destinationViewController as! TilePopupViewController
        var index = sender as! Int
        tpvc.SelectedTile = tiles[index].tile
        tpvc.SelectedImage = tiles[index].photo

        tpvc.disablePictureInteraction()
    }

}
