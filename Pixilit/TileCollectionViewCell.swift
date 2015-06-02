//
//  BusinessPhotoCollectionViewCell.swift
//  Pixilit
//
//  Created by Tyree, Spencer on 2/9/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class TileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Photo: UIImageView!
    @IBOutlet weak var pixd: UIImageView!
    
    var currentTile = Tile()
    //@IBOutlet weak var Description: UILabel!
    //@IBOutlet weak var Desc2: UITextView!
    //var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singletap")
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(tile: Tile?, img: UIImage?)
    {
        autoresizesSubviews = true

        Photo.contentMode = .ScaleToFill
        Photo.frame = contentView.bounds
        Photo.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        Photo.layer.cornerRadius = 8.0
        Photo.clipsToBounds = true
        
        if img != nil {
            Photo.image = img!
        } else {
            Photo.image = UIImage()
            Photo.backgroundColor = UIColor(red: 120, green: 120, blue: 120, alpha: 0.5)
        }
        
        if tile != nil {
            currentTile = tile!
            setPixd();
        }
        
        if (User.Role == AccountType.Business)
        {
            pixd.hidden = true
            pixd.userInteractionEnabled = false
        }
        else if User.Role == AccountType.User {
            pixd.hidden = false
            pixd.userInteractionEnabled = true
        }
        
    }
    
    func setPixd()
    {
        if User.IsLoggedIn() {
            if currentTile.Pixd == true {
                pixd.image = UIImage(named: "unpix")
            } else {
                pixd.image = UIImage(named: "pix")
            }
        }
        else {
            pixd.image = UIImage()
            
        }
    }
}
