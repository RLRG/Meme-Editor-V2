//
//  CreateMemeViewController.swift
//  MemeApp
//
//  Created by Gmv100 on 19/06/16.
//  Copyright © 2016 GMV. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var activityButton: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var navBarConstraint: NSLayoutConstraint!
    
    
    // MARK: Lifecycle & initialization methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -5.0,
            ]
        
        // Top & bottom textfields
        inititializeTextFieldWithAttributes(topText, text: "TOP", attributes: memeTextAttributes)
        inititializeTextFieldWithAttributes(bottomText, text: "BOTTOM", attributes: memeTextAttributes)
    }

    func inititializeTextFieldWithAttributes(textfield: UITextField, text: String, attributes: [String:AnyObject])
    {
        textfield.text = text
        textfield.delegate = self
        textfield.defaultTextAttributes = attributes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disabling camera button when there is no camera available in the phone.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Subscribing keyboard notification
        subscribeToKeyboardNotifications()
        
        // If there is any image selected, the activity button will be enabled. On the other hand, it won't be enabled.
        if imageView.image != nil {
            activityButton.enabled = true
        }else{
            activityButton.enabled = false
        }
        
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribing keyboard notification
        unsubscribeToKeyboardNotifications()
    }
    
    
    // MARK: Notifications: subscribe & unsubscribe methods
    
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self , selector: #selector(CreateMemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateMemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: Keyboard methods
    
    func keyboardWillShow(notification: NSNotification)
    {
        if (bottomText.isFirstResponder())
        {
            let offset:CGFloat = getKeyboardHeight(notification)
            self.view.frame.origin.y -= offset
            navBarConstraint.constant -= offset
        }
    }
    
    func keyboardWillHide (notification: NSNotification)
    {
        if (bottomText.isFirstResponder())
        {
            let offset:CGFloat = getKeyboardHeight(notification)
            self.view.frame.origin.y += offset
            navBarConstraint.constant += offset
        }
    }
    
    func getKeyboardHeight (notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    // MARK: Navbar & toolbar actions
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let nextController = UIImagePickerController()
        nextController.delegate = self
        
        if sender.tag == 0 {
            nextController.sourceType = .Camera
        }
        else if sender.tag == 1 {
            nextController.sourceType = .PhotoLibrary
        }
        
        presentViewController(nextController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        let meme = createMeme()
        let controller = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType, completed: Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            if !completed {
                print("Error")
            }
                // TODO: BE CAREFUL, CHECK THIS !!!!!!
            else if (activityType == UIActivityTypeSaveToCameraRoll || activityType == UIActivityTypeCopyToPasteboard){
                // Add it to the memes array in the Application Delegate
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
            }
            
            self.navigationController!.popToRootViewControllerAnimated(true)
        }
        self.presentViewController(controller, animated: true, completion: nil)

    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        
        activityButton.enabled = false
        topText.text = "TOP"
        imageView.image = nil
        bottomText.text = "BOTTOM"
    }
    
    
    // MARK: UImagePickerControllerDelegate methods
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: UITextFieldDelagate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Meme creation methods
    
    func createMeme() -> Meme {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imageView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
        return meme
    }
    
    func generateMemedImage() -> UIImage
    {
        // Hide toolbar and navbar
        navigationController?.navigationBarHidden = true
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navigationController?.navigationBarHidden = false
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
}