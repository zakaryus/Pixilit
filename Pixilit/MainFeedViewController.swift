//
//  MainFeedViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/6/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

public class MainFeedViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, CollectionViewWaterfallLayoutDelegate
{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex = NSIndexPath()
    var selectedTile: Tile = Tile()
    var refresh = UIRefreshControl()
    var hasLoggedIn = false
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
    var tiles:[(tile: Tile, photo: UIImage, photoSize: CGSize, hasImage: Bool)]=[]
    var allTiles:[(tile: Tile, photo: UIImage, photoSize: CGSize, hasImage: Bool)]=[]
    var filteredTiles:[(tile: Tile, photo: UIImage, photoSize: CGSize, hasImage: Bool)]=[]
    let reuseId = "tileCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var pageCounter: Int = 0
    let PAGESIZE: Int = 12

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        var logo = UIImage(named: "newLogo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
       self.view.backgroundColor = HelperTransformations.BackgroundColor()
        self.presentingViewController?.providesPresentationContextTransitionStyle = true
        self.presentingViewController?.definesPresentationContext = true
        
        refresh.addTarget(self, action: "PullToRefresh", forControlEvents: .ValueChanged)
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")


        // Do any additional setup after loading the view, typically from a nib.
   
    }
    
    
    override public func viewWillAppear(animated: Bool) {
   
        println(User.Uid)
        if hasLoggedIn == false && User.IsLoggedIn()
        {
            hasLoggedIn = true
            pageCounter = 0
            Refresh()
        }
        else if hasLoggedIn == true && !User.IsLoggedIn()
        {
            hasLoggedIn = false
            pageCounter = 0
            Refresh()
        }
        else if tiles.count == 0 {
            pageCounter = 0
            Refresh()
        }
        
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
            self.allTiles.removeAll(keepCapacity: false)
            self.collectionView.reloadData()
        }
        
        
        var tid = "all"
  
        if(User.IsLoggedIn()) {
            var first = true
            if User.Regions.count != 0 {
                tid = ""
                for region in User.Regions {
                    if first {
                        tid += "\(region.TID!)"
                        first = false
                    }
                    else {
                        tid += ",\(region.TID!)"
                        
                    }
                }
            }
        }
       
        HelperREST.RestMainFeedRequest(tid, page: pageCounter) {
            Tiles in
            
            if self.pageCounter == 0 {
                self.tiles.removeAll(keepCapacity: false)
                self.allTiles.removeAll(keepCapacity: false)
            }
          
            for tile in Tiles {
                self.tiles.append(tile: tile, photo: UIImage(), photoSize: CGSizeMake(0, 0), hasImage: false)
            }
            
            self.allTiles = self.tiles
            
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
        }
        
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tiles.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
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
    
    func registerTaps(cell: TileCollectionViewCell) {
        var singleTap = UITapGestureRecognizer(target: self, action: "segueToPopup:")
        singleTap.numberOfTapsRequired = 1
        var doubleTap = UITapGestureRecognizer(target: self, action: "picDoubleTapped:")
        doubleTap.numberOfTapsRequired = 2
        
        cell.addGestureRecognizer(singleTap)
        cell.addGestureRecognizer(doubleTap)
        
        singleTap.requireGestureRecognizerToFail(doubleTap)
    }
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var size = tiles[indexPath.row].photoSize
        if size == CGSize(width: 0, height: 0) {
            tiles[indexPath.row].photoSize = HelperTransformations.Scale(HelperTransformations.ScaleSize.HalfScreen, itemToScale: tiles[indexPath.row].tile.PhotoMetadata!, containerWidth: self.view.frame.width)
            var ps = tiles[indexPath.row].photoSize
            println("Main Feed View width: \(ps.width), height: \(ps.height)")

        }
        
        return tiles[indexPath.row].photoSize
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
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
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndex = indexPath
        //self.performSegueWithIdentifier("FeedToBusinessSegue", sender: indexPath.row)
        
    }
    
    func filterContentForSearchText(searchText: String)
    {
        // Filter the array using the filter method
        var tmpFilter: [(tile: Tile, photo: UIImage, photoSize: CGSize, hasImage: Bool)]=[]
        
        for item in allTiles {
            
            var tags = item.tile.TagList()
            var desc = item.tile.Description != nil ? item.tile.Description! : ""
            
            if tags.lowercaseString.rangeOfString(searchText.lowercaseString) != nil {
                tmpFilter.append(item)
            } else if desc.lowercaseString.rangeOfString(searchText.lowercaseString) != nil {
                tmpFilter.append(item)
            }
        }
        
        self.tiles = tmpFilter
    }
    
    public func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        if searchString == "" {
            tiles = allTiles
            self.collectionView.reloadData()
        } else {
            self.filterContentForSearchText(searchString)
            self.collectionView.reloadData()
        }
        
        return true
    }
    
    public func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool
    {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }

    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    func segueToPopup(sender: UITapGestureRecognizer!) {
        self.performSegueWithIdentifier("FeedToBusinessSegue", sender: selectedIndex.row)
    }
    
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var tpvc = segue.destinationViewController as! TilePopupViewController
        var index = sender as! Int
        tpvc.SelectedTile = tiles[index].tile
        tpvc.SelectedImage = tiles[index].photo
        var cell = collectionView.cellForItemAtIndexPath(selectedIndex) as! TileCollectionViewCell
        tpvc.CurrentCell = cell
    }
    
   }
