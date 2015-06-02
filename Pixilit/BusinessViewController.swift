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
    @IBOutlet weak var moreInfoButton: UIButton!
   

    @IBOutlet var collectionView: UICollectionView!

    var image : UIImage!

    
    var mintyForest = UIColor.clearColor()//(red: 228, green: 247, blue: 242, alpha: 1)
    var business: Business = Business()
    var tiles:[(tile: Tile, photo: UIImage, photoSize: CGSize, hasImage: Bool)]=[]
    var selectedTile: Tile = Tile()
    let reuseId = "tileCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var refresh = UIRefreshControl()
    var selectedIndex = NSIndexPath()
    var pageCounter: Int = 0
    let PAGESIZE: Int = 12
    
    //hide status bar-->carrier and battery
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func moreInfoPressed(sender: AnyObject) {
        println("more info button pressed")
      performSegueWithIdentifier("MoreBusinessInfo", sender: "")
    }
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
          self.view.backgroundColor = HelperTransformations.BackgroundColor()
        if let title = business.Title {
            
            self.businessNavBar.title = title
        }
  
        // Do any additional setup after loading the view, typically from a nib.
     
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        refresh.addTarget(self, action: "PullToRefresh", forControlEvents: .ValueChanged)
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        Refresh()
    }
    
    func PullToRefresh() {
        pageCounter = 0
        Refresh()
    }
    
    func Refresh() {
        collectionView.insertSubview(refresh, aboveSubview: collectionView)
        refresh.beginRefreshing()
        
        if self.pageCounter == 0 {
            self.tiles.removeAll(keepCapacity: false)
            self.collectionView.reloadData()
        }
        
        HelperREST.RestBusinessTiles(business.Uid!, page: pageCounter) {
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
        
        //decide when to update pageCounter and call refresh
        if (PAGESIZE * pageCounter) + (PAGESIZE / 2) == indexPath.row - 1 {
            pageCounter++
            Refresh()
        }
        
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
    
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        println("inside prepareforseg")
        var segueName = segue.identifier
        
        if segueName == "MoreBusinessInfo"
        {
            println("I AM IN MORE BUSINESSINFOR SEG")
            var a = segue.destinationViewController as! MoreBusinessInfoController
            a.InfoBusiness = self.business
        }
        else
        {

        var tpvc = segue.destinationViewController as! TilePopupViewController
        var index = sender as! Int
        tpvc.SelectedTile = tiles[index].tile
        tpvc.SelectedImage = tiles[index].photo

        tpvc.disablePictureInteraction()
        }
    }

}
