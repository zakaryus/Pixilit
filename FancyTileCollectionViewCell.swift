//
//  FancyTileCollectionViewCell.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/17/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class FancyTileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var photoDescription: UITextView!
    @IBOutlet weak var tags: UITextView!
    @IBOutlet weak var businessPhoto: UIImageView!
    @IBOutlet weak var businessName: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImage = UIImageView()
        photoDescription = UITextView()
        tags = UITextView()
        businessPhoto = UIImageView()
        businessName = UITextView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainImage = UIImageView()
        photoDescription = UITextView()
        tags = UITextView()
        businessPhoto = UIImageView()
        businessName = UITextView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mainImage = UIImageView()
        photoDescription = UITextView()
        tags = UITextView()
        businessPhoto = UIImageView()
        businessName = UITextView()
    }
    
    func setup(tile: Tile, img: UIImage) {
        mainImage = UIImageView()
        if var image = mainImage {
            image.image = img
        }
        //mainImage.image = img
        photoDescription.text = tile.description
        for tag in tile.tags {
            tags.text? += tag
            tags.text? += ","
        }
        
        println(tags.text)
        
        HelperURLs.UrlToImage(tile.BusinessLogo!) {
            Photo in
            self.businessPhoto.image = Photo
        }
        businessName.text = tile.BusinessName
        
    }

}
