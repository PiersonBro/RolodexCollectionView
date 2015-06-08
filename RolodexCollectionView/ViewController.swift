//
//  ViewController.swift
//  RolodexCollectionView
//
//  Created by E&Z Pierson on 5/3/15.
//  Copyright (c) 2015 Rez Works. All rights reserved.
//

import UIKit
import Cartography

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var colorViews = [UIView]()
    let button = UIButton.buttonWithType(.System) as! UIButton
    var collectionView: UICollectionView?
    static let reuseIdentifier = "com.rolodexCell.rezworks"
    var draggingHandler: DraggingHandler? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 300, height: 300)
        // one vertical scrolling collumn
        flowLayout.minimumInteritemSpacing = 1000
        
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView?.delegate = self
        collectionView?.backgroundColor = .blackColor()
        collectionView?.dataSource = self
        
        view.addSubview(collectionView!)
        constrain(collectionView!) { collectionView in
            collectionView.center == collectionView.superview!.center
            collectionView.size == collectionView.superview!.size
        }
        
        collectionView!.registerClass(RolodexCollectionViewCell.self, forCellWithReuseIdentifier: ViewController.reuseIdentifier)
        draggingHandler = DraggingHandler(collectionView: collectionView!)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewController.reuseIdentifier, forIndexPath: indexPath) as! RolodexCollectionViewCell
        
        if cell.draggingHandler == nil {
            cell.draggingHandler = draggingHandler
        }
        
        return cell
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

public extension UIColor {
    static func randomColor() -> UIColor {
        let colors: [UIColor] = [redColor(), blueColor(), greenColor(), grayColor(), whiteColor(), cyanColor(), yellowColor(), orangeColor(), purpleColor(), brownColor()]
        let randomIndex = Int(arc4random() % UInt32(colors.count))
        
        return colors[randomIndex]
    }
}
