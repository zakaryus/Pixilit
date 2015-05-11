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
    
    @IBOutlet weak var BtnPhoto: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var BtnUpload: UIBarButtonItem!
    @IBOutlet weak var TbDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.TbDescription.delegate = self
        self.BtnUpload.enabled = false
        self.TbDescription.hidden = true
    }
    
    @IBAction func BtnPhotoClicked(sender: AnyObject) {
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                //self.Camera()
                
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        var gallaryAction = UIAlertAction(title: "Photo Album", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                //self.PhotoAlbum()
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
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
            popover!.presentPopoverFromRect(BtnPhoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    @IBAction func BtnUploadClick(sender: AnyObject) {
        
        var imgData: NSData = UIImageJPEGRepresentation(imageView.image, 1.0)
        
        var base64 = imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
           println(base64)
        var fileData = HelperStrings.RestFileJsonString(base64)
        var json = HelperREST.RestRequest(Config.RestFileCreate, content: fileData, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
        
        var fid = json["fid"].string
        var nodeData =  HelperStrings.RestNodeJsonString(User.Uid, description: TbDescription.text, fid: fid!)
        
     
        println(nodeData)
        
        var json2 = HelperREST.RestRequest(Config.RestNodeCreate, content: nodeData, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])

        println(json2)
        
        self.BtnUpload.enabled = false
        self.TbDescription.hidden = true
        self.TbDescription.text = "Enter Description..."
        self.imageView.image = UIImage()
    }
    
   func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
    
        picker.dismissViewControllerAnimated(true, completion: nil)
        var tmpImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = tmpImage
        RotateImage()
        imageView.contentMode = .ScaleAspectFit
        self.TbDescription.hidden = false
    }
    
    func RotateImage() -> UIImage
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
            popover=UIPopoverController(contentViewController: imagePicker)
            popover!.presentPopoverFromRect(BtnPhoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
}