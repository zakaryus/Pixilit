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
    var user: User = User()
    
    


    let reuseId = "userPhotoCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setName() //update username
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        //Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.user.Pixd.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as TileCollectionViewCell
      
        Helper.NidToTile(user.Pixd[indexPath.row])
            {
                Tile in
                
                cell.Description.text = Tile.Description
                
                Helper.UrlToImage(Tile.Photo!) {
                    Photo in
                    cell.Photo.image = Photo
                }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            return CGSize(width: 198, height: 288)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }


    
    func setName() {
      
        usernameField.text=self.user.Username
    }
    
    
}

