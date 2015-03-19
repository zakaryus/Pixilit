//
//  MainFeedViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/6/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet var collectionView: UICollectionView!
    var tiles:[(tile: Tile, photo: UIImage)]=[]
    
    let reuseId = "tileCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
        Refresh()
    }
    
    override func viewWillAppear(animated: Bool) {        
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tiles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as TileCollectionViewCell
 
        cell.Desc2.editable = true
        cell.Desc2.text = tiles[indexPath.row].tile.Description!
        cell.Desc2.editable = false
        println(cell.Desc2.text)
        
        cell.Photo.image = tiles[indexPath.row].photo

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            var tile = tiles[indexPath.row].tile
            
            Helper.UrlToImage(tiles[indexPath.row].tile.Photo!) {
                Photo in
                self.tiles[indexPath.row].photo = Photo
            }
            
            println("width: \(tiles[indexPath.row].photo.size.width), height: \(tiles[indexPath.row].photo.size.height)")
            
            return CGSize(width: tiles[indexPath.row].photo.size.width, height: tiles[indexPath.row].photo.size.height)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }

}
