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

@objc public class DraggingHandler: NSObject, UIDynamicAnimatorDelegate {
    let collectionView: UICollectionView
    let dynamicAnimator: UIDynamicAnimator
    
    var currentAttachmentBehavior: UIAttachmentBehavior? = nil
    var currentSnapBehavior: UISnapBehavior? = nil
    var currentGestureRecognizer: UIGestureRecognizer? = nil
    // This is so that when `dynamicAnimatorDidPause` is called we can intelligently dispose of resources.
    var gestureRecognizerState: UIGestureRecognizerState? = nil
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        dynamicAnimator = UIDynamicAnimator(referenceView: collectionView)
        super.init()
        dynamicAnimator.delegate = self
    }
    
    public func cellWasDragged(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer != currentGestureRecognizer && currentGestureRecognizer != nil {
            return
        } else {
            currentGestureRecognizer = gestureRecognizer
        }
        
        let location = gestureRecognizer.locationInView(collectionView)
        gestureRecognizerState = gestureRecognizer.state
        
        switch gestureRecognizer.state {
            case .Began:
            let indexPath = collectionView.indexPathForItemAtPoint(location)

            if let indexPath = indexPath {
                let cell = collectionView.cellForItemAtIndexPath(indexPath)!
            
                currentAttachmentBehavior = UIAttachmentBehavior(item: cell, attachedToAnchor: cell.center)
                dynamicAnimator.addBehavior(currentAttachmentBehavior!)
                
                currentSnapBehavior = UISnapBehavior(item: cell, snapToPoint: cell.center)
            } else {
                // Do nothing.
            }
            
            case .Changed:
            currentAttachmentBehavior?.anchorPoint = location
            let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            findDirection(panGestureRecognizer.velocityInView(collectionView))

            case .Ended:
                dynamicAnimator.addBehavior(currentSnapBehavior)
                dynamicAnimator.removeBehavior(currentAttachmentBehavior)
            case .Cancelled:
                gestureRecognizer.enabled = true
            
            default:
                break
        }
    }
    
    private enum Direction {
        case Right
        case Left
        case Up
        case Down
    }
    
    private func findDirection(velocity: CGPoint) -> Direction {
        println(velocity)
        if velocity.x > 0 {
            return .Right
        } else {
            return .Left
        }
    }
    
    public func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        if gestureRecognizerState == .Ended || gestureRecognizerState == .Cancelled {
            cleanUpState()
        }
    }
    
    private func cleanUpState() {
        dynamicAnimator.removeAllBehaviors()
        
        currentAttachmentBehavior = nil
        currentGestureRecognizer = nil
        currentSnapBehavior = nil
    }
}
