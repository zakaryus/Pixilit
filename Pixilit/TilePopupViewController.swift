//
//  TilePopupViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/20/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class TilePopupViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageDescription: UITextView!
    @IBOutlet weak var imageTags: UITextView!
    @IBOutlet weak var businessLogo: UIImageView!
    @IBOutlet weak var businessTitle: UITextView!
    @IBOutlet weak var popupView: UIView!
    //var pixdButton = UIButton()
    @IBOutlet weak var pixdButton: UIButton!
    var business: Business?
    private var _SelectedTile: Tile?
    var userInteraction = true
    var SelectedTile : Tile {
        get {
            return _SelectedTile!
        }
        set(value) {
            //add stuff later
            //if value
            
            _SelectedTile = value
        }
    }
    
    private var _SelectedImage: UIImage?
    var SelectedImage : UIImage {
        get {
            return _SelectedImage!
        }
        set(value) {
            //add stuff later
            //if value
            
            _SelectedImage = value
        }
    }
    @IBAction func dismissViewController(sender: AnyObject) {
        //SelectedTile.
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HelperREST.RestBusinessRequest(SelectedTile.BusinessID!) {
            business in
            self.business = business
        }
        image.image = SelectedImage
        image.userInteractionEnabled = userInteraction
        
        var dimensions = HelperTransformations.Scale(HelperTransformations.ScaleSize.FullScreen, itemToScale: image.image!.size, containerWidth: popupView.frame.width)
        image.frame.size = dimensions
        var pictureTapped =  UITapGestureRecognizer(target: self, action: "segueToBusiness:")
        pictureTapped.numberOfTapsRequired = 1
        image.addGestureRecognizer(pictureTapped)
        //var popupView = createContainerView()
          //self.view.addSubview(popupView)
        println("SUBVIEWS: \(self.view.subviews)")
        //var puvHeight = NSLayoutConstraint.constraintsWithVisualFormat(<#format: String#>, options: <#NSLayoutFormatOptions#>, metrics: <#[NSObject : AnyObject]?#>, views: <#[NSObject : AnyObject]#>)
        //popupView.center = self.view.center

        
        imageDescription.text = SelectedTile.Description
        for tag in SelectedTile.tags {
            var modifiedString = tag.stringByReplacingOccurrencesOfString("&amp;", withString: "&", options: NSStringCompareOptions.LiteralSearch, range: nil)
            imageTags.text! += "\(modifiedString), "
        }
        
        if let logo = SelectedTile.BusinessLogo {
            //rest request
            HelperURLs.UrlToImage(logo) {
                photo in
                self.businessLogo.image = photo
            }
        }
        
        if let businessname = SelectedTile.BusinessName {
            businessTitle.text = SelectedTile.BusinessName
        }
        
        if User.IsLoggedIn() {
            if SelectedTile.Pixd == true {
                pixdButton.setImage(UIImage(named: "pixd"), forState: .Normal)
            }
            else {
                pixdButton.setImage(UIImage(named: "unpixd"), forState: .Normal)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func segueToBusiness(sender: UITapGestureRecognizer!)
    {
        println("tap gesture recognized, preparing to segue");
        self.performSegueWithIdentifier("popupToBusinessSegue", sender: "")
    }
    
    @IBAction func pixdButtonPressed(sender: AnyObject) {
        println("pixd button pressed")
        
        HelperREST.RestFlag(SelectedTile.Nid!, pixd : SelectedTile.Pixd!) {
            success in
            println("\(success) this sucs")
            if success == true
            {
                self.SelectedTile.Pixd = self.SelectedTile.Pixd == true ? false : true
            }
        }
        
        
        if SelectedTile.Pixd == true {
            pixdButton.setImage(UIImage(named: "pixd"), forState: .Normal)
        }
        else {
            pixdButton.setImage(UIImage(named: "unpixd"), forState: .Normal)
        }
        
        //notify observers
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
