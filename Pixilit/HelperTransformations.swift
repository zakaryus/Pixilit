//
//  HelperTransformations.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/23/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

struct HelperTransformations
{
        enum ScaleSize {
            case HalfScreen
            case FullScreen
        }
    
        //assumes constant width
        static func Scale(size: ScaleSize, img: UIImage, containerWidth: CGFloat) -> CGSize {
            let scale: CGFloat = size == ScaleSize.HalfScreen ? 0.475 : 0.875
    
            let imgW = img.size.width
            let imgH = img.size.height
    
            let newImgW = ceil(containerWidth * scale)
            let newImgH = ceil((newImgW * imgH) / imgW)
    
            return CGSizeMake(newImgW, newImgH)
        }
}
