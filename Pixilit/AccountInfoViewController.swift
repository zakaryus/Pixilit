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
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        var gallaryAction = UIAlertAction(title: "Photo Album", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                //self.PhotoAlbum()
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.navigationItem.rightBarButtonItem = self.BtnUpload
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
        
        aiLoading.hidden = false
        aiLoading.startAnimating()
        
        var imgData: NSData = UIImageJPEGRepresentation(imageView.image, 1.0)
        
        var base64 = imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        var fileData = HelperStrings.RestFileJsonString(base64)
        var json = HelperREST.RestRequest(Config.RestFileCreate, content: fileData, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
        
        var fid = json["fid"].string
        var nodeData =  HelperStrings.RestNodeJsonString(User.Uid, description: TbDescription.text, fid: fid!)
        
        
        var json2 = HelperREST.RestRequest(Config.RestNodeCreate, content: nodeData, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
        
        self.BtnUpload.enabled = false
        self.TbDescription.hidden = true
        self.TbDescription.text = "Enter Description..."
        self.TbDescription.textColor = UIColor.lightGrayColor()
        self.imageView.image = UIImage()
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = BtnPhoto
        aiLoading.stopAnimating()

    }
    
   func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
    
        picker.dismissViewControllerAnimated(true, completion: nil)
        var tmpImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = tmpImage
      //  RotateImage()
        imageView.contentMode = .ScaleAspectFit
        self.TbDescription.hidden = false
    }
    
   /* func RotateImage() -> UIImage
    {
  
        if self.imageView.image!.imageOrientation == UIImageOrientation.Up {
            return imageView.image!
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransformIdentity
        
        switch self.imageView.image!.imageOrientation {
            case UIImageOrientation.Down, UIImageOrientation.DownMirrored:
                transform = CGAffineTransformTranslate(transform, self.imageView.image!.size.width, self.imageView.image!.size.height)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
                break
            
            case UIImageOrientation.Left, UIImageOrientation.LeftMirrored:
                transform = CGAffineTransformTranslate(transform, self.imageView.image!.size.width, 0)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
                break
                
            case UIImageOrientation.Right, UIImageOrientation.RightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, self.imageView.image!.size.height)
                transform = CGAffineTransformRotate(transform, -CGFloat(M_PI_2))
                break
            case UIImageOrientation.Up, UIImageOrientation.UpMirrored:
                break
        }
        
        self.imageView.transform = transform
        return imageView.image!
    }*/
    
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