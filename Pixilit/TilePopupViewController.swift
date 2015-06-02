//
//  TilePopupViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/20/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class TilePopupViewController: UIViewController {

    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageDescription: UITextView!
    @IBOutlet weak var imageTags: UITextView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var pixdButton: UIButton!
    var business: Business?
    private var _SelectedTile: Tile?
    var userInteraction = true
    var CurrentCell : TileCollectionViewCell!
    
    var SelectedTile : Tile {
        get {
            return _SelectedTile!
        }
        set(value) {
  
            _SelectedTile = value
        }
    }
    
    private var _SelectedImage: UIImage?
    var SelectedImage : UIImage {
        get {
            return _SelectedImage!
        }
        set(value) {
            _SelectedImage = value
        }
    }
    @IBAction func dismissViewController(sender: AnyObject) {
        //SelectedTile.
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    //hide status bar-->carrier and battery
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HelperREST.RestBusinessRequest(SelectedTile.BusinessID!) {
            business in
            self.business = business
        }
        
        if (User.Role == AccountType.Business || User.Role == AccountType.Anonymous)
        {
            pixdButton.hidden = true
            pixdButton.userInteractionEnabled = false
        }
        image.image = SelectedImage
        image.userInteractionEnabled = userInteraction


        var pictureTapped =  UITapGestureRecognizer(target: self, action: "segueToBusiness:")
        pictureTapped.numberOfTapsRequired = 2
        
        var textTapped =  UITapGestureRecognizer(target: self, action: "hideInteractions:")
        textTapped.numberOfTapsRequired = 1
        
        image.addGestureRecognizer(textTapped)
        
        image.addGestureRecognizer(pictureTapped)

       
        imageDescription.text = SelectedTile.Description
        imageTags.text = "";
        var first = true
        for tag in SelectedTile.tags {
            var modifiedString = tag.stringByReplacingOccurrencesOfString("&amp;", withString: "&", options: NSStringCompareOptions.LiteralSearch, range: nil)
            if (first) {
                imageTags.text! += modifiedString
                first = false
            }
            else {
                imageTags.text! += ", \(modifiedString)"
            }
            
        }
        
        
        
        setPixdIconPopup()
    }
    
    
    func setPixdIconPopup()
    {
        if User.IsLoggedIn() {
            if SelectedTile.Pixd == true {
                pixdButton.setImage(UIImage(named: "unpix"), forState: .Normal)
            }
            else {
                pixdButton.setImage(UIImage(named: "pix"), forState: .Normal)
            }
        }

    }
    
    func hideInteractions(sender:UITapGestureRecognizer!)
    {
        if (imageDescription.hidden == false )
        {

        imageDescription.hidden = true
        imageTags.hidden = true
        
        if User.Role != AccountType.Business {
        pixdButton.hidden = true
        pixdButton.enabled = false
            }
            
        goBack.hidden = true
        goBack.enabled = false
            
        }
        else
        {
            imageDescription.hidden = false
            imageTags.hidden = false
            
            if User.Role != AccountType.Business {
            pixdButton.hidden = false
            pixdButton.enabled = true
            }
            
            goBack.hidden = false
            goBack.enabled = true
        }
    }
    
    
    func segueToBusiness(sender: UITapGestureRecognizer!)
    {
        println("tap gesture recognized, preparing to segue");
        self.performSegueWithIdentifier("popupToBusinessSegue", sender: "")
    }
    
    
    @IBAction func pixdButtonPressed(sender: AnyObject) {
        println("pixd button pressed")
        if(self.SelectedTile.Pixd == true)
        {
            CurrentCell.pixd.image = UIImage(named: "pix")
            println("THIS IS PIXD")
            self.SelectedTile.Pixd == false
            pixdButton.setImage(UIImage(named: "pix"), forState: .Normal)

        }
        else if (self.SelectedTile.Pixd == false){
            CurrentCell.pixd.image = UIImage(named: "unpix")
            self.SelectedTile.Pixd == true
            pixdButton.setImage(UIImage(named: "unpix"), forState: .Normal)
            println ("THIS IS NOT PIXED")
        }
        
        
        var flagged = SelectedTile.Pixd == false ? "flag" : "unflag"
        var content = "{\"flag_name\":\"pixd\",\"entity_id\":\"\(SelectedTile.Nid!)\",\"uid\":\"\(User.Uid)\",\"action\":\"\(flagged)\"}"
        var success = HelperREST.RestRequest(Config.RestFlagJson, content: content, method: HelperREST.HTTPMethod.Post,  headerValues: [("X-CSRF-Token",User.Token)])
        
        if success[0].stringValue == "true"
        {
           SelectedTile.Pixd = SelectedTile.Pixd == true ? false : true
        }

       }

    func disablePictureInteraction()
    {
        userInteraction = false;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var bvc = segue.destinationViewController as! BusinessViewController
        bvc.business = self.business!
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
