//
//  RolodexCollectionViewCell.swift
//  RolodexCollectionView
//
//  Created by E&Z Pierson on 5/21/15.
//  Copyright (c) 2015 Rez Works. All rights reserved.
//

import UIKit
import Cartography

class RolodexCollectionViewCell: UICollectionViewCell {
    let colorView = UIView(frame: CGRect())
    let label = UILabel(frame: CGRect())
    var gestureRecognizer: UIPanGestureRecognizer? = nil
    // Note this must be set 
    var draggingHandler: DraggingHandler? = nil {
        didSet {
            if let draggingHandler = draggingHandler {
                self.gestureRecognizer = UIPanGestureRecognizer(target: draggingHandler, action: "cellWasDragged:")
                addGestureRecognizer(self.gestureRecognizer!)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // MARK: ColorView
        colorView.backgroundColor = .randomColor()
        contentView.addSubview(colorView)
        constrain(colorView) { colorView in
            colorView.centerX == colorView.superview!.centerX
            colorView.centerY == colorView.superview!.centerY
            colorView.width == colorView.superview!.width
            colorView.height == colorView.width
        }
        
        // MARK: Label
        label.text = "Hello World"
        colorView.addSubview(label)
        constrain(label) { label in
            label.center == label.superview!.center
        }
        
        // MARK: Cardify
        contentView.layer.sublayerTransform = perspectiveTransform()
        colorView.layer.shouldRasterize = true
        colorView.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func perspectiveTransform() -> CATransform3D {
    let angleOfRotation = CGFloat(M_PI * -40 / 180)
    let rotation = CATransform3DMakeRotation(angleOfRotation, 1.0, 0, 0)
    
    let depth: CGFloat = 300
    let translateDown = CATransform3DMakeTranslation(0, 0, -depth)
    let translateUp = CATransform3DMakeTranslation(0, 0, depth)
    var scale = CATransform3DIdentity
    scale.m34 = -1.0/1500
    let perspective = CATransform3DConcat(CATransform3DConcat(translateDown, scale), translateUp)
    
    return CATransform3DConcat(rotation, perspective)
}
