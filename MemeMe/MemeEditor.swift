//
//  MemeEditor.swift
//  MemeMe
//
//  Created by Carlos Lopes Pereira on 07/04/15.
//  Copyright (c) 2015 Carlos Lopes Pereira. All rights reserved.
//

import UIKit

class MemeEditor: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do initial setup
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.shareMemeButton.enabled = false

        // if there are no previously shared memes, do not allow viewing the table/collection
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if delegate.memes.count == 0 {
            self.cancelButton.enabled = false
        } else {
            self.cancelButton.enabled = true
        }
        
        // Set text attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes

        // Why not do it with placeholder text?
        self.topTextField.text = "TOP"
        self.topTextField.textAlignment = NSTextAlignment.Center
        self.topTextField.delegate = self
        self.bottomTextField.text = "BOTTOM"
        self.bottomTextField.textAlignment = NSTextAlignment.Center
        self.bottomTextField.delegate = self
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let imageToShare = generateMemedImage()
        
        // instantiate, configure and present an activity VC to share the meme
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            activityVC.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func saveMeme() {
        // Create meme
        let memedImage = generateMemedImage()
        var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, image: imageView.image!, memedImage: memedImage)
        
        // Add meme to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        NSLog("Meme has been added to global array")
    }
    
    func generateMemedImage() -> UIImage {
        self.toolbar.hidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.toolbar.hidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        return memedImage
    }
    
    @IBAction func cancelMeme() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.shareMemeButton.enabled = true
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        // FIXME: what if the user actually wants TOP or BOTTOM to be shown?
        // Using placeholder text in the initial setup would fix this
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: accommodate keyboard methods
    func subscribeToKeyboardNotifications() {
        // We want to know when the keyboard will show
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        // We want to know when the keyboard will hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        NSLog("Received UIKeyboardWillShowNotification notification.")
        if bottomTextField.editing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}

