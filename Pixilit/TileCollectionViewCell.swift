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
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Desc2: UITextView!
    //var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singletap")
    
    init(tile: Tile) {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init()
        //fatalError("init(coder:) has not been implemented")
    }
}
