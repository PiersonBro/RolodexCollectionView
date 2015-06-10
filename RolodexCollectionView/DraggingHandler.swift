//
//  DraggingHandler.swift
//  RolodexCollectionView
//
//  Created by E&Z Pierson on 6/7/15.
//  Copyright (c) 2015 Rez Works. All rights reserved.
//

import UIKit

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
            dynamicAnimator.addBehavior(currentSnapBehavior!)
            dynamicAnimator.removeBehavior(currentAttachmentBehavior!)
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
        print(velocity)
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
