//
//  AccountInfoViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation
import UIKit

class AccountInfoViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate {
    
    @IBOutlet weak var BtnPhoto: UIButton!
    var imagePicker = UIImagePickerController()
    var popover:UIPopoverController?=nil
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
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
        var imgData: NSData = UIImagePNGRepresentation(imageView.image)
        var base64 = imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)

        var content = "{\"file\":{\"file\": \"\(base64)\",\"filename\":\"my_first_image.png\",\"uri\":\"public://my_first_image.png\"}}"
        var json = HelperREST.RestRequest("http://104.236.227.190/rest/file", content: content, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
        
        var fid = json["fid"].string
        
        var content2 = "{\"type\" : \"tile\",\"title\" : \"first image upload test\",\"language\" : \"und\",\"field_description\": {\"und\": [{\"value\": \"description test\"}]},\"field_image\": {\"und\": [{\"fid\": \"\(fid)\"}]}}"
        
        var json2 = HelperREST.RestRequest("http://104.236.227.190/rest/node", content: content2, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])

        println(json2)
        
    }
    
   func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
    
        picker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = .ScaleAspectFit
        
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