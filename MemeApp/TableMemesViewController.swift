//
//  TableMemesViewController.swift
//  MemeApp
//
//  Created by Gmv100 on 23/06/16.
//  Copyright © 2016 GMV. All rights reserved.
//

import Foundation
import UIKit

class TableMemesViewController: UITableViewController {
    
    @IBOutlet var memesTableView: UITableView!
    var memes:[Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memesTableView.delegate = self
        memesTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        memesTableView.reloadData()
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableReusableId") as! customTableCell
        cell.customCellImage.image = memes[indexPath.row].memedImage
        cell.customCellLabel.text = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
