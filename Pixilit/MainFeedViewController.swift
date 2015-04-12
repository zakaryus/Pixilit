//
//  MainFeedViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/6/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

public class MainFeedViewController: UIViewController, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate
{
    
    @IBOutlet var collectionView: UICollectionView!
    var tiles:[(tile: Tile, photo: UIImage)]=[]
    
    let reuseId = "tileCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var refresh = UIRefreshControl()

    override public func viewDidLoad() {
        super.viewDidLoad()

             // Do any additional setup after loading the view, typically from a nib.
        self.title = "Main Feed"
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
        Refresh()
    }
    
    override public func viewWillAppear(animated: Bool) {        
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
        Refresh()
    }
    
    func Refresh()
    {
        Helper.RestMainFeedRequest() {
            Tiles in
            
            println(Tiles.count)
            self.tiles = []
            
            for tile in Tiles {
                self.tiles.append(tile: tile, photo: UIImage())
            }
            
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
        }

    }

    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tiles.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as TileCollectionViewCell
 
        cell.Desc2.editable = true
        cell.Desc2.text = tiles[indexPath.row].tile.Description!
        cell.Desc2.editable = false
        println(cell.Desc2.text)
        
        
        //println("photo.frame:\(cell.Photo.frame) cell.frame:\(cell.frame)")
        //cell.Photo.frame = cell.frame
        //println("photo.frame:\(cell.Photo.frame) cell.frame:\(cell.frame)")

        //cell.Photo.contentMode = .ScaleAspectFill
//        cell.Photo.autoresizingMask = ( .FlexibleBottomMargin
//                                        | .FlexibleHeight
//                                        | .FlexibleLeftMargin
//                                        | .FlexibleRightMargin
//                                        | .FlexibleTopMargin
//                                        | .FlexibleWidth )
        cell.Photo.image = tiles[indexPath.row].photo
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        Helper.UrlToImage(tiles[indexPath.row].tile.Photo!) {
            Photo in
            self.tiles[indexPath.row].photo = Photo
        }
        
        let imageW = tiles[indexPath.row].photo.size.width
        let imageH = tiles[indexPath.row].photo.size.height
        println("width: \(imageW), height: \(imageH)")
        
        let screenW = self.view.frame.width / 2.2
        let screenH = (screenW * imageH) / imageW
        
        return CGSizeMake(screenW, screenH)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        return UICollectionReusableView()
    }

}
