//
//  OpenMemeViewController.swift
//  MemeApp
//
//  Created by Gmv100 on 24/06/16.
//  Copyright © 2016 GMV. All rights reserved.
//

import Foundation
import UIKit

class OpenMemeViewController: UIViewController {

    @IBOutlet weak var openMemeImage: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        openMemeImage.image = meme.memedImage
    }
    
}