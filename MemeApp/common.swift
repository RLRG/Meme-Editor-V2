//
//  common.swift
//  MemeApp
//
//  Created by Gmv100 on 04/07/16.
//  Copyright © 2016 GMV. All rights reserved.
//

import Foundation
import UIKit

class commonFunctions {

    func createMemeAction (navigationController:UINavigationController?, storyboard:UIStoryboard?) {
        
        if let navigationController = navigationController
        {
            let createMemeController = storyboard!.instantiateViewControllerWithIdentifier("CreateMemeViewController") as! CreateMemeViewController
            
            let transition:CATransition = createTransition()
            navigationController.view.layer.addAnimation(transition, forKey: kCATransition)
            navigationController.pushViewController(createMemeController, animated: true)
        }
    }
    
    func createTransition () -> CATransition
    {
        let transition:CATransition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        
        return transition
    }
}
