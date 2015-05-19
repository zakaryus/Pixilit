//
//  AccountInfoViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation
import UIKit

class AccountInfoViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITextViewDelegate {
    
    var imagePicker = UIImagePickerController()
    var popover:UIPopoverController?=nil
    
    var BtnPhoto: UIBarButtonItem!
    var BtnUpload: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var TbDescription: UITextView!
    @IBOutlet weak var tvInstructionPlaceholder: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.view.backgroundColor = UIColor.clearColor()
        self.imagePicker.delegate = self
        self.TbDescription.delegate = self
        self.TbDescription.hidden = true
        self.TbDescription.text = "Enter Description..."
        self.TbDescription.textColor = UIColor.lightGrayColor()
        
        BtnPhoto = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "BtnPhotoClicked:")
        BtnPhoto.enabled = true
        BtnUpload = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "BtnUploadClick:")
        BtnUpload.enabled = false
        self.navigationItem.rightBarButtonItem = BtnPhoto
    }
    
    func BtnPhotoClicked(sender: UIBarButtonItem) {
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                //self.Camera()
                
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.navigationItem.rightBarButtonItem = self.BtnUpload
                self.tvInstructionPlaceholder.hidden = true
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        var gallaryAction = UIAlertAction(title: "Photo Album", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                //self.PhotoAlbum()
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.navigationItem.rightBarButtonItem = self.BtnUpload
                self.tvInstructionPlaceholder.hidden = true
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                self.navigationItem.rightBarButtonItem = self.BtnPhoto
                
        }
        
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover = UIPopoverController(contentViewController: alert)
            //popover!.presentPopoverFromRect(BtnPhoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    }
    
    func BtnUploadClick(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("UploadingSegue", sender: self)

        var downloadQueue = dispatch_queue_create("downloader", nil);
        dispatch_async(downloadQueue, {
            
            
            // do our long running process here
            var imgData: NSData = UIImageJPEGRepresentation(self.imageView.image, 1.0)
            var base64 = imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
            var fileData = HelperStrings.RestFileJsonString(base64)
            var json = HelperREST.RestRequest(Config.RestFileCreate, content: fileData, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
            var fid = json["fid"].string
            var nodeData =  HelperStrings.RestNodeJsonString(User.Uid, description: self.TbDescription.text, fid: fid!)
            var json2 = HelperREST.RestRequest(Config.RestNodeCreate, content: nodeData, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
            
            
            // do any UI stuff on the main UI thread
            dispatch_async(dispatch_get_main_queue(), {
                self.BtnUpload.enabled = false
                self.TbDescription.hidden = true
                self.TbDescription.text = "Enter Description..."
                self.TbDescription.textColor = UIColor.lightGrayColor()
                self.imageView.image = UIImage()
                self.navigationController?.navigationBar.topItem?.rightBarButtonItem = self.BtnPhoto
                self.tvInstructionPlaceholder.hidden = false
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
        })
    }
    
   func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
    
        picker.dismissViewControllerAnimated(true, completion: nil)
        var initialImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let orientedImage = HelperTransformations.FixOrientation(initialImage!)
        imageView.image = orientedImage
        imageView.contentMode = .ScaleAspectFit
        self.TbDescription.hidden = false
    }
    
    func textViewDidChange(textView: UITextView) {
        if(!textView.text.isEmpty)
        {
            self.BtnUpload.enabled = true
        }
        else {
            self.BtnUpload.enabled = false
        }
    }

    

    func Camera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(imagePicker, animated: true, completion: nil)
        }
        else
        {
            PhotoAlbum()
        }
    }
    
    func PhotoAlbum()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        else
        {
            popover = UIPopoverController(contentViewController: imagePicker)
            //popover!.presentPopoverFromRect(BtnPhoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }

}