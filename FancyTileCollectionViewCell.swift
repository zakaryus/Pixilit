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
        self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
    }
    
    func setup(tile: Tile, img: UIImage, rect: CGSize) {

        mainImage.frame = CGRectMake(0, 0, rect.width, rect.height)
        mainImage.autoresizesSubviews = true
        mainImage.contentMode = .ScaleAspectFit
        mainImage.autoresizingMask = .FlexibleHeight
        mainImage.image = img

        photoDescription.text = "new photo description" //tile.description
//        for tag in tile.tags {
//            tags.text? += tag
//            tags.text? += ","
//        }
        
        tags.text = "new photo tags"
        
        //println(tags.text)
        
//        HelperURLs.UrlToImage(tile.BusinessLogo!) {
//            Photo in
//            self.businessPhoto.image = Photo
//        }
        businessName.text = "new business name" //tile.BusinessName
        self.layoutIfNeeded()
        self.setNeedsLayout()
        self.contentView.setNeedsLayout()
        self.contentView.bounds = self.bounds
        println("bounds width: \(self.bounds.width) height: \(self.bounds.height)")
    }

}
