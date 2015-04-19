//
//  MainFeedViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/6/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

public class MainFeedViewController: UIViewController, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate, CustomIOS7AlertViewDelegate
{
    
    @IBOutlet var collectionView: UICollectionView!
    var tiles:[(tile: Tile, photo: UIImage)]=[]
    var selectedTile: Tile = Tile()
    let reuseId = "fancyTile"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var refresh = UIRefreshControl()
    var page: Int = 0
    var measuringCell: FancyTileCollectionViewCell?

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Main Feed"
        collectionView!.registerNib(UINib(nibName: "FancyTileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)

        Setup()
    }
    
    override public func viewWillAppear(animated: Bool) {        
        //Setup()
    }
    
    func Setup() {
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
        Refresh()
    }
    
    func Refresh() {
        HelperREST.RestMainFeedRequest(page) {
            Tiles in
            
            println(Tiles.count)
            self.tiles = []
            
            for tile in Tiles {
                self.tiles.append(tile: tile, photo: UIImage())
            }
            
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
        }

    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tiles.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: FancyTileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! FancyTileCollectionViewCell
        
//        if cell.businessPhoto == nil {
//            cell = FancyTileCollectionViewCell()
//        }
        
//        HelperURLs.UrlToImage(tiles[indexPath.row].tile.Photo!) {
//            Photo in
//            self.tiles[indexPath.row].photo = Photo
//        }
//        
//        if (indexPath.item < tiles.count) {
//            
//            // pre-fetch the next 'page' of data.
//            if(indexPath.item == (tiles.count - 8 + 1)){
//                fetchMoreItems()
//            }
            var rect = scale(ScaleSize.HalfScreen, img: tiles[indexPath.row].photo)

            cell.setup(tiles[indexPath.row].tile, img: tiles[indexPath.row].photo, rect: rect)
//        } else {
//            fetchMoreItems()
//            return loadingCellForIndexPath(indexPath)
//        }

        //cell.setup(tiles[indexPath.row].tile, img: tiles[indexPath.row].photo)
        //cell.sizeToFit()
        return cell
    }
    
    func fetchMoreItems()
    {
        HelperREST.RestMainFeedRequest(++page) {
            Tiles in
            
            println(Tiles.count)
            //self.tiles = []
            
            if Tiles.count == 0 {
                self.page = -1
                return
            }
            
            for tile in Tiles {
                self.tiles.append(tile: tile, photo: UIImage())
            }
            
            self.collectionView.reloadData()
            //self.refresh.endRefreshing()
        }
    }
    
    func loadingCellForIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell: FancyTileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! FancyTileCollectionViewCell
    
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = cell.center;
        cell.addSubview(activityIndicator)
    
        activityIndicator.startAnimating()
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        HelperURLs.UrlToImage(tiles[indexPath.row].tile.Photo!) {
            Photo in
            self.tiles[indexPath.row].photo = Photo
        }
        
        var cell = measuringCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("FancyTileCollectionViewCell", owner: self, options: nil)[0] as? FancyTileCollectionViewCell
            measuringCell = cell
        }

        var rect = scale(ScaleSize.HalfScreen, img: tiles[indexPath.row].photo)
        
        println("rect width: \(rect.width) height: \(rect.height)")
        measuringCell?.setup(tiles[indexPath.row].tile, img: tiles[indexPath.row].photo, rect: rect)

        println("width: \(measuringCell!.frame.size.width) height: \(measuringCell!.frame.size.height)")
        //return measuringCell!.frame.size
        
        return measuringCell!.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        return UICollectionReusableView()
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //collectionView.collectionViewLayout.invalidateLayout()
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FancyTileCollectionViewCell
        println("index: \(indexPath.row) tapped: \(cell.frame.height)")
        
        let buttons = ["Back", "Pix", "Business"]
        
        // Create a new AlertView instance
        let alertView = CustomIOS7AlertView()
        
        // Set the button titles array
        alertView.buttonTitles = buttons
        
        // Set a custom container view
        alertView.containerView = createContainerView(cell, img: tiles[indexPath.row].photo)
        
        // Set self as the delegate
        alertView.delegate = self
        
        // Show time!
        alertView.show()
        selectedTile = tiles[indexPath.row].tile
    }
    
    // Handle button touches
    func customIOS7AlertViewButtonTouchUpInside(alertView: CustomIOS7AlertView, buttonIndex: Int) {
        println("DELEGATE: Button '\(alertView.buttonTitles![buttonIndex])' touched")
        if alertView.buttonTitles![buttonIndex] == "Business" {
            var businessid = selectedTile.BusinessID
            HelperREST.RestBusinessRequest(businessid!) {
                business in
                
                self.performSegueWithIdentifier("FeedToBusinessSegue", sender: business)
            }
        }
        
        //else if alertView.buttonTitles![buttonIndex] == "Pix"
        //else if alertView.buttonTitles![buttonIndex] == "Back"
        alertView.close()
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var bvc = segue.destinationViewController as! BusinessViewController
        bvc.business = sender as! Business
    }
    
    // Create a custom container view
    func createContainerView(cell: UICollectionViewCell, img: UIImage) -> UIView {
        var rect = scale(ScaleSize.FullScreen, img: img)
        
        //create the imageview of appropriate size
        var ivFullScreen = UIImageView()
        ivFullScreen.frame = CGRectMake(0, 0, rect.width, rect.height)
        ivFullScreen.autoresizesSubviews = true
        ivFullScreen.contentMode = .ScaleAspectFit
        ivFullScreen.autoresizingMask = .FlexibleHeight
        ivFullScreen.image = img
        
        //create the container of appropriate size
        //the container width is always 85% of the screen width
        //the container height is the minimum of the screen height
        //or the image height
        var maxW = self.view.frame.width * 0.85
        var maxH = min(rect.height, self.view.frame.height * 0.85)
        var containerView = UIView(frame: CGRectMake(0, 0, maxW, maxH))
        containerView.autoresizesSubviews = true
        containerView.clipsToBounds = true
        containerView.contentMode = .ScaleAspectFit
        containerView.autoresizingMask = .FlexibleHeight
        
        //if the imageview is longer than the container
        if(maxH != rect.width) {
            //add a scrollview for the imageview
            var scroll = UIScrollView()
            scroll.frame = containerView.frame
            scroll.showsHorizontalScrollIndicator = false
            scroll.showsVerticalScrollIndicator = true
            scroll.scrollEnabled = true
            scroll.userInteractionEnabled = true
            scroll.contentSize = rect
            scroll.addSubview(ivFullScreen)
            containerView.addSubview(scroll)
        }
        else {
            containerView.addSubview(ivFullScreen)
        }
        
        return containerView
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
}
