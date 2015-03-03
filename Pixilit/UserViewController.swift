//
//  UserViewController.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var usernameField: UITextField!
    var user : String = ""
    var userTiles : [Tile] = [Tile]()
    let reuseId = "userPhotoCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    //var collectVC = UICollectionViewController()
    var refresh = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setName() //update username
       // collectVC.collectionView = collectionView
        
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
        Refresh()
    }
    
    func Refresh()
    {
        Helper.userFlags(User.Uid)
            {
                Tiles in
                self.userTiles = Tiles
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
        
        return userTiles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as TileCollectionViewCell
      
     
                var Tile = userTiles[indexPath.row]
                cell.Description.text = Tile.Description
                
                Helper.UrlToImage(Tile.Photo!) {
                    Photo in
                    cell.Photo.image = Photo
        }

                    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            return CGSize(width: 98, height: 288)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }


    
    func setName() {

        usernameField.text = User.Username
    }
    
    
}

