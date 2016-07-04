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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewOutlet.dataSource = self
        collectionViewOutlet.delegate = self
        
        // Customizing the collection cells - UICollectionViewLayout
        let space: CGFloat = 3.0
        let dimensionX = (self.view.frame.size.width - (2*space))/3.0
        let dimensionY = (self.view.frame.size.height - (2*space))/5.0
        flowLayoutObject.minimumInteritemSpacing = space
        flowLayoutObject.minimumLineSpacing = space
        flowLayoutObject.itemSize = CGSizeMake(dimensionX, dimensionY)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        collectionViewOutlet.reloadData()
    }
    
    @IBAction func createMemeAction(sender: AnyObject) {
        
        if let navigationController = self.navigationController
        {
            let createMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeViewController") as! CreateMemeViewController
            
            let transition:CATransition = createTransition()
            navigationController.view.layer.addAnimation(transition, forKey: kCATransition)
            navigationController.pushViewController(createMemeController, animated: true)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionReusableId", forIndexPath: indexPath) as! customCollectionCell
        cell.customCollectionCellImage.image = memes[indexPath.row].memedImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let openController = self.storyboard!.instantiateViewControllerWithIdentifier("OpenMemeViewController") as! OpenMemeViewController
        openController.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(openController, animated: true)
        
    }
    
    func createTransition () -> CATransition
    {
        let transition:CATransition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        
        return transition
    }
    
}