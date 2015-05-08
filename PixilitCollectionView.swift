//
//  PixilitCollectionView.swift
//  Pixilit
//
//  Created by SPT Pixilit on 5/8/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation


public class PixilitCollectionView: UICollectionView, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {
    
    var tiles:[(tile: Tile, photo: UIImage, photoSize: CGSize, hasImage: Bool)]=[]
    let reuseId = "tileCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tiles.count
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! TileCollectionViewCell
        
        if !tiles[indexPath.row].hasImage {
            HelperURLs.UrlToImage(tiles[indexPath.row].tile.Photo!) {
                Photo in
                self.tiles[indexPath.row].photo = Photo
                self.tiles[indexPath.row].hasImage = true
            }
        }
        
        cell.setup(self.tiles[indexPath.row].tile, img: self.tiles[indexPath.row].photo)
        registerTaps(cell)
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
            tiles[indexPath.row].photoSize = HelperTransformations.Scale(HelperTransformations.ScaleSize.HalfScreen, itemToScale: tiles[indexPath.row].tile.PhotoMetadata!, containerWidth: self.frame.width)
            var ps = tiles[indexPath.row].photoSize
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
    
    func segueToPopup(sender: UITapGestureRecognizer!) {
        self.performSegueWithIdentifier("FeedToBusinessSegue", sender: selectedIndex.row)
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

    
}