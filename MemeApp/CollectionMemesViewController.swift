//
//  CollectionMemesViewController.swift
//  MemeApp
//
//  Created by Gmv100 on 23/06/16.
//  Copyright © 2016 GMV. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class CollectionMemesViewController: UICollectionViewController {
    
    @IBOutlet var collectionViewOutlet: UICollectionView!
    @IBOutlet weak var flowLayoutObject: UICollectionViewFlowLayout!
    
    var memes:[Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    // MARK: Lifecycle & initialization methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewOutlet.dataSource = self
        collectionViewOutlet.delegate = self
        
        // Customizing the collection cells - UICollectionViewLayout
        let space: CGFloat = 3.0
        let dimensionX = (view.frame.size.width - (2*space))/3.0
        let dimensionY = (view.frame.size.height - (2*space))/5.0
        flowLayoutObject.minimumInteritemSpacing = space
        flowLayoutObject.minimumLineSpacing = space
        flowLayoutObject.itemSize = CGSizeMake(dimensionX, dimensionY)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        collectionViewOutlet.reloadData()
    }
    
    
    // MARK: Creating a new meme
    
    @IBAction func createMemeAction(sender: AnyObject) {
        
        let commonFunc:commonFunctions = commonFunctions()
        commonFunc.createMemeAction(navigationController, storyboard: storyboard)
    }
    
    
    // MARK: UICollectionViewDelegate & UICollectionViewDataSource methods
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionReusableId", forIndexPath: indexPath) as! customCollectionCell
        cell.customCollectionCellImage.image = memes[indexPath.row].memedImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let openController = storyboard!.instantiateViewControllerWithIdentifier("OpenMemeViewController") as! OpenMemeViewController
        openController.meme = memes[indexPath.row]
        navigationController?.pushViewController(openController, animated: true)
        
    }
}
