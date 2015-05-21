//
//  UserViewController.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class UserViewController: UIViewController , UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate{
    
    
    @IBOutlet weak var nbiHeader: UINavigationItem!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var newsButton: UIBarButtonItem!
    var selectedIndex = NSIndexPath()
    var tiles:[(tile: Tile, photo: UIImage, photoSize: CGSize, hasImage: Bool)]=[]
    //var user : String = ""
    let reuseId = "userPhotoCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    //var collectVC = UICollectionViewController()
    var refresh = UIRefreshControl()
    
    override func viewWillAppear(animated: Bool) {
        if !User.IsLoggedIn()
        {
              self.performSegueWithIdentifier("GoLogin", sender: self)
        } else {
            nbiHeader.title = User.Username
        }
        if User.Role == AccountType.Business || User.Role == AccountType.Admin {
            newsButton.enabled = true
            newsButton.title = "News"
        }
        else {
            newsButton.title = ""
            newsButton.enabled = false
            newsButton.title = ""
        }
        Refresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = HelperTransformations.BackgroundColor()
        println(User.Uid)
       // collectVC.collectionView = collectionView
        
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
      
    }
    
    func Refresh()
    {
        if (User.Role == AccountType.Business)
        {
            HelperREST.RestBusinessTiles(User.Uid) {
                Tiles in
                
                
                self.tiles = []
                
                for tile in Tiles {
                    self.tiles.append(tile: tile, photo: UIImage(), photoSize: CGSizeMake(0, 0), hasImage: false)
                }
                
                self.collectionView.reloadData()
                self.refresh.endRefreshing()
            }
        }
        else
        {
            HelperREST.RestUserFlags(User.Uid)
                {
                    Tiles in
                    
                    
                    self.tiles = []
                    
                    for tile in Tiles {
                        self.tiles.append(tile: tile, photo: UIImage(), photoSize: CGSizeMake(0, 0), hasImage: false)
                    }
                    
                    self.collectionView.reloadData()
                    self.refresh.endRefreshing()
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        //Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tiles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        println(tiles.count)
        let cell: TileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! TileCollectionViewCell
        
        if !tiles[indexPath.row].hasImage {
            cell.setup(nil, img: nil)
            println(tiles[indexPath.row].tile.Photo!)
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
        }
        
        return tiles[indexPath.row].photoSize
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
    
    
    func picDoubleTapped(sender: UITapGestureRecognizer!)
    {
        if !User.IsLoggedIn() {
            return
        }
        println("double tap")
        
        var flagged = tiles[self.selectedIndex.row].tile.Pixd == false ? "flag" : "unflag"
        var content = HelperStrings.RestUpdateFlagString(tiles[selectedIndex.row].tile.Nid!, uid: User.Uid, flagged: flagged)
        var success = HelperREST.RestRequest(Config.RestFlagJson, content: content, method: HelperREST.HTTPMethod.Post,  headerValues: [("X-CSRF-Token",User.Token)])
        
        if success[0].stringValue == "true"
        {
            self.tiles[self.selectedIndex.row].tile.Pixd = self.tiles[self.selectedIndex.row].tile.Pixd == true ? false : true
            tiles.removeAtIndex(selectedIndex.row)
            self.collectionView.reloadData()
        }
    }
    
    func setCellPix() {
        var cell: TileCollectionViewCell = collectionView.cellForItemAtIndexPath(selectedIndex) as! TileCollectionViewCell
        cell.setPixd()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndex = indexPath

        
    }
    
    func segueToPopup(sender: UITapGestureRecognizer!) {
        self.performSegueWithIdentifier("userToPopupView", sender: selectedIndex.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userToPopupView" {
            var tpvc = segue.destinationViewController as! TilePopupViewController
            var index = sender as! Int
            tpvc.SelectedTile = tiles[index].tile
            tpvc.SelectedImage = tiles[index].photo
        }
    }


}

