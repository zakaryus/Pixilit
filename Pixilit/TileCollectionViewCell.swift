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
    
    func setup(tile: Tile, img: UIImage)
    {
        //Desc2.editable = true
        //Desc2.text = tile.Description!
        //Desc2.editable = false
        
        autoresizesSubviews = true

        Photo.contentMode = .ScaleToFill
        Photo.frame = contentView.bounds
        Photo.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        Photo.image = img
        Photo.layer.cornerRadius = 8.0
        Photo.clipsToBounds = true
        currentTile = tile
        setPixd();
        
        }
    
    func setPixd()
    {
        if User.isLoggedIn() {
            if currentTile.Pixd == true {
                pixd.image = UIImage(named: "pixd")
            } else {
                pixd.image = UIImage(named: "unpixd")
            }
        }
    }
}
