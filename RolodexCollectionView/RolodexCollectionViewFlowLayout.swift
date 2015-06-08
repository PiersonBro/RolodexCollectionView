//
//  RolodexCollectionViewFlowLayout.swift
//  RolodexCollectionView
//
//  Created by E&Z Pierson on 5/21/15.
//  Copyright (c) 2015 Rez Works. All rights reserved.
//

import UIKit

class RolodexCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private var dynamicAnimator: UIDynamicAnimator? = nil

    override init() {
        super.init()
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        
        // MARK: Flow Layout Configuration
        itemSize = CGSize(width: 300, height: 300)
        // One centered column
        minimumInteritemSpacing = 1000
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        let contentSize = collectionView?.contentSize
        let items = super.layoutAttributesForElementsInRect(CGRect(origin: CGPoint(x: 0, y: 0), size: contentSize!)) as! [UIDynamicItem]
        
        if dynamicAnimator?.behaviors.count == 0 {
            for item in items {
                let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
                // DO STUFF HERE
                attachmentBehavior.length = 0.0
                attachmentBehavior.damping = 0.8
                attachmentBehavior.frequency = 1.0

                dynamicAnimator?.addBehavior(attachmentBehavior)
            }
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return dynamicAnimator!.itemsInRect(rect)
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return dynamicAnimator!.layoutAttributesForCellAtIndexPath(indexPath)
    }
}
