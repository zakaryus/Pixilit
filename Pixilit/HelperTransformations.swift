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
        static func Scale(size: ScaleSize, itemToScale: CGSize, containerWidth: CGFloat) -> CGSize {
            let scale: CGFloat = size == ScaleSize.HalfScreen ? 0.475 : 0.875
    
            let itemW = itemToScale.width
            let itemH = itemToScale.height
    
            let newItemW = ceil(containerWidth * scale)
            let newItemH = ceil((newItemW * itemH) / itemW)
    
            return CGSize(width: newItemW, height: newItemH)
        }
}
