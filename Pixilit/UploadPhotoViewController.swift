//
//  AccountInfoViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation
import UIKit

class UploadPhotoViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITextViewDelegate, writeValueBackDelegate {
    
    var imagePicker = UIImagePickerController()
    var popover:UIPopoverController?=nil
    
    var BtnPhoto: UIBarButtonItem!
    var BtnUpload: UIBarButtonItem!
    
    var desc: String!
    var regions: [String] = []
    var tags: [String] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tvInstructionPlaceholder: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = HelperTransformations.BackgroundColor()
        self.imagePicker.delegate = self

        BtnPhoto = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "BtnPhotoClicked:")
        BtnPhoto.enabled = true
        BtnUpload = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "BtnUploadClick:")
        BtnUpload.enabled = false
        self.navigationItem.rightBarButtonItem = BtnPhoto
    }
    
    @IBAction func BtnAddClicked(sender: AnyObject) {
        if imageView.image != nil {
            self.performSegueWithIdentifier("segueAddRegionsTags", sender: self)
        } else {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "No Photo"
            alertView.message = "Please begin by taking a photo!"
            alertView.delegate = self
            
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        
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
            popover!.presentPopoverFromRect(CGRectMake(0, 0, self.view.frame.width, 50), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    }
    
    func BtnUploadClick(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("segueUploading", sender: self)

        var downloadQueue = dispatch_queue_create("downloader", nil);
        dispatch_async(downloadQueue, {
            
            
            // do our long running process here
            var imgData: NSData = UIImageJPEGRepresentation(self.imageView.image, 1.0)
            var base64 = imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
            var fileData = HelperStrings.RestFileJsonString(base64)
            var json = HelperREST.RestRequest(Config.RestFileCreate, content: fileData, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
            var fid = json["fid"].string
            
            
            println("\n\n\n\n\nLOOK AT ME: " + self.desc)
            var nodeData =  HelperStrings.RestNodeJsonString(User.Uid, description: self.desc, fid: fid!, regions: self.regions, tags: self.tags)
            var json2 = HelperREST.RestRequest(Config.RestNodeCreate, content: nodeData, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
            
            
            // do any UI stuff on the main UI thread
            dispatch_async(dispatch_get_main_queue(), {
                self.BtnUpload.enabled = false
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
    }
    
    func writeValueBack(description: String, regions: [String], tags: [String]) {
        
        self.desc = description
        self.regions = regions
        self.tags = tags
        
        self.BtnUpload.enabled = true
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueAddRegionsTags"
        {
            var secondViewController = (segue.destinationViewController as! AddRegionsTagsViewController)
            secondViewController.delegate = self
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
            popover!.presentPopoverFromRect(CGRectMake(0, 0, self.view.frame.width, 50), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
   }