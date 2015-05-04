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
    
    private var _SelectedTile: Tile?
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

        image.image = SelectedImage

        var dimensions = HelperTransformations.Scale(HelperTransformations.ScaleSize.FullScreen, itemToScale: image.image!.size, containerWidth: popupView.frame.width)
        image.frame.size = dimensions
        //var popupView = createContainerView()
          //self.view.addSubview(popupView)
        println("SUBVIEWS: \(self.view.subviews)")
        //var puvHeight = NSLayoutConstraint.constraintsWithVisualFormat(<#format: String#>, options: <#NSLayoutFormatOptions#>, metrics: <#[NSObject : AnyObject]?#>, views: <#[NSObject : AnyObject]#>)
        //popupView.center = self.view.center

        
        imageDescription.text = SelectedTile.Description
        for tag in SelectedTile.tags {
            imageTags.text! += "\(tag), "
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
                //pixdImage.image = UIImage(named: "pixd")
                pixdButton.setImage(UIImage(named: "pixd"), forState: .Normal)
            }
            else {
                //pixdImage.image = UIImage(named: "unpixd")
                pixdButton.setImage(UIImage(named: "unpixd"), forState: .Normal)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func createContainerView() -> UIView {
        var rect = HelperTransformations.Scale(HelperTransformations.ScaleSize.FullScreen, itemToScale: SelectedImage.size, containerWidth: self.view.frame.width)

        //create the imageview of appropriate size
        var image = UIImageView()
        image.frame = CGRectMake(0, 0, rect.width, rect.height)
        image.autoresizesSubviews = true
        image.contentMode = .ScaleAspectFit
        image.autoresizingMask = .FlexibleHeight
        image.image = SelectedImage
        
        var bigger = max(rect.width * 0.1, rect.height * 0.1)
        pixdButton.frame = CGRectMake(0, 0, bigger, bigger)
        pixdButton.autoresizesSubviews = true
        pixdButton.contentMode = .ScaleAspectFit
        pixdButton.autoresizingMask = .FlexibleHeight
        
        
        
        var pixdImage = UIImageView()
        //pixdImage.frame = CGRectMake(0, 0, rect.width * 0.1, rect.height * 0.1)
        pixdImage.autoresizesSubviews = true
        pixdImage.contentMode = .ScaleAspectFit
        pixdImage.autoresizingMask = .FlexibleHeight
        
        if User.IsLoggedIn() {
            if SelectedTile.Pixd == true {
                //pixdImage.image = UIImage(named: "pixd")
                pixdButton.setImage(UIImage(named: "pixd"), forState: .Normal)
            }
            else {
                //pixdImage.image = UIImage(named: "unpixd")
                pixdButton.setImage(UIImage(named: "unpixd"), forState: .Normal)
            }
            
            pixdButton.addTarget(self, action: "pixdButtonPressed:", forControlEvents:.TouchUpInside)
            
            //image.addSubview(pixdImage)
            image.userInteractionEnabled = true
            image.addSubview(pixdButton)
        }
        
        //create the container of appropriate size
        //the container width is always 85% of the screen width
        //the container height is the minimum of the screen height
        //or the image height
        var maxW = self.view.frame.width * 0.85
        var maxH = min(rect.height, self.view.frame.height * 0.75)
        maxH *= 1.2
        println("max W: \(maxW) \n maxH: \(maxH)")
        var pictureView = UIView(frame: CGRectMake(0, 0, maxW, maxH))
        pictureView.frame = CGRectMake(0, 0, maxW, maxH)
        pictureView.autoresizesSubviews = true
        pictureView.clipsToBounds = true
        pictureView.contentMode = .ScaleAspectFit
        pictureView.autoresizingMask = .FlexibleHeight
        
        //if the imageview is longer than the container
        if(maxH != rect.width) {
            //add a scrollview for the imageview
            var scroll = UIScrollView()
            scroll.frame = pictureView.frame
            scroll.showsHorizontalScrollIndicator = false
            scroll.showsVerticalScrollIndicator = true
            scroll.scrollEnabled = true
            scroll.userInteractionEnabled = true
            scroll.contentSize = rect
            scroll.addSubview(image)
            pictureView.addSubview(scroll)
        }
        else {
            pictureView.addSubview(image)
        }

        //add everything else
        var imageDescription = UITextView()
        imageDescription.text = SelectedTile.Description
        imageDescription.editable = false
        imageDescription.frame = CGRectMake(0, maxH - (maxH * 0.1), maxW, maxH * 0.05)
        imageDescription.autoresizesSubviews = true
        imageDescription.clipsToBounds = true
        imageDescription.contentMode = .ScaleAspectFit
        imageDescription.autoresizingMask = .FlexibleHeight
        
        pictureView.addSubview(imageDescription)
        
        var tagsTextField = UITextView()
        var tags = ""
        for tag in SelectedTile.tags {
            tags += "\(tag), "
        }
        //tags = tags.substringToIndex(String.Index(count(tags)))
        tagsTextField.text = tags
        tagsTextField.editable = false
        tagsTextField.frame = CGRectMake(0, maxH - (maxH * 0.05), maxW, maxH * 0.05)
        tagsTextField.autoresizesSubviews = true
        tagsTextField.clipsToBounds = true
        tagsTextField.contentMode = .ScaleAspectFit
        tagsTextField.autoresizingMask = .FlexibleHeight
        
        pictureView.addSubview(tagsTextField)
        
//        var businessLogo = UIImageView()
//        businessLogo.frame = CGRectMake(0, 0, rect.width * 0.1, rect.height * 0.1)
//        businessLogo.autoresizesSubviews = true
//        businessLogo.contentMode = .ScaleAspectFit
//        businessLogo.autoresizingMask = .FlexibleHeight
//        HelperURLs.UrlToImage(SelectedTile.BusinessLogo!) {
//            photo in
//            businessLogo.image = photo
//        }
        
        
        return pictureView
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
            //pixdImage.image = UIImage(named: "pixd")
            pixdButton.setImage(UIImage(named: "pixd"), forState: .Normal)
        }
        else {
            //pixdImage.image = UIImage(named: "unpixd")
            pixdButton.setImage(UIImage(named: "unpixd"), forState: .Normal)
        }
        
        //notify observers
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
