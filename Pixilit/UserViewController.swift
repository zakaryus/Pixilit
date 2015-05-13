//
//  UserViewController.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var newsButton: UIBarButtonItem!

 
    //var user : String = ""
    var tiles:[(tile: Tile, photo: UIImage)]=[]
    let reuseId = "userPhotoCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    //var collectVC = UICollectionViewController()
    var refresh = UIRefreshControl()
    
    override func viewWillAppear(animated: Bool) {
        if !User.IsLoggedIn()
        {
              self.performSegueWithIdentifier("GoLogin", sender: self)
        }
        usernameField.text = User.Username
        if User.Role == AccountType.Business || User.Role == AccountType.Admin {
            newsButton.enabled = true
            newsButton.title = "News"
        }
        else {
            newsButton.enabled = false
            newsButton.title = ""
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        println(User.Uid)
       // collectVC.collectionView = collectionView
        
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
        Refresh()
    }
    
    func Refresh()
    {
        HelperREST.RestUserFlags(User.Uid)
            {
                Tiles in
                
            
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
       
        //Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.tiles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! TileCollectionViewCell
        
        cell.setup(tiles[indexPath.row].tile, img: tiles[indexPath.row].photo)
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            var tile = tiles[indexPath.row].tile
            
            HelperURLs.UrlToImage(tiles[indexPath.row].tile.Photo!) {
                Photo in
                self.tiles[indexPath.row].photo = Photo
            }
            
            println("width: \(tiles[indexPath.row].photo.size.width), height: \(tiles[indexPath.row].photo.size.height)")
            
            return CGSize(width: tiles[indexPath.row].photo.size.width, height: tiles[indexPath.row].photo.size.height)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }

}

