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
    let reuseId = "tile"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var refresh = UIRefreshControl()
    var page: Int = 0

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Main Feed"

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
        var cell: TileCVC = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! TileCVC
        
        var tile = tiles[indexPath.row].tile
        var photo = tiles[indexPath.row].photo
        
        var rect = scale(ScaleSize.HalfScreen, img: tiles[indexPath.row].photo)
        println("cell photo width: \(rect.width) height: \(rect.height)")

        cell.Photo.frame = CGRectMake(0, 0, cell.frame.size.width - 16, rect.height)
        cell.Photo.autoresizesSubviews = true
        cell.Photo.contentMode = .ScaleAspectFit
        cell.Photo.autoresizingMask = .FlexibleHeight
        cell.Photo.image = photo
        
        cell.Description.text = tile.Description == nil ? "<Empty>" : tile.Description
        cell.Tags.text = ""
        for tag in tile.tags {
            cell.Tags.text! += "\(tag), "
        }
        cell.Business.text = tile.BusinessName == nil ? "<Empty>" : tile.BusinessName
        
        println("cell width: \(cell.frame.size.width) height: \(cell.frame.size.height)")
        
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
    
        let cell: TileCVC = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! TileCVC
    
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

        var rect = scale(ScaleSize.HalfScreen, img: tiles[indexPath.row].photo)
        
        return CGSize(width: rect.width + 16, height: rect.height + 200)
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
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TileCVC
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
