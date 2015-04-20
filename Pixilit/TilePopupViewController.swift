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
    @IBOutlet weak var pictureView: UIView!
    
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
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //image.image = SelectedImage
        createContainerView()
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
        // Do any additional setup after loading the view.
    }
    
    func createContainerView() -> UIView {
        var rect = scale(ScaleSize.FullScreen, img: SelectedImage)
        
        //create the imageview of appropriate size
        //var ivFullScreen = UIImageView()
        image.frame = CGRectMake(0, 0, rect.width, rect.height)
        image.autoresizesSubviews = true
        image.contentMode = .ScaleAspectFit
        image.autoresizingMask = .FlexibleHeight
        image.image = SelectedImage
        
        //create the container of appropriate size
        //the container width is always 85% of the screen width
        //the container height is the minimum of the screen height
        //or the image height
        var maxW = self.view.frame.width * 0.85
        var maxH = min(rect.height, self.view.frame.height * 0.85)
        println("max W: \(maxW) \n maxH: \(maxH)")
        //pictureView = UIView(frame: CGRectMake(0, 0, maxW, maxH))
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
        
        return pictureView
    }
    
    enum ScaleSize {
        case HalfScreen
        case FullScreen
    }
    
    //assumes constant width
    func scale(size: ScaleSize, img: UIImage) -> CGSize {
        let scale: CGFloat = size == ScaleSize.HalfScreen ? 0.475 : 0.875
        
        let imgW = img.size.width
        let imgH = img.size.height
        
        let newImgW = ceil(self.view.frame.width * scale)
        let newImgH = ceil((newImgW * imgH) / imgW)
        
        return CGSizeMake(newImgW, newImgH)
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
