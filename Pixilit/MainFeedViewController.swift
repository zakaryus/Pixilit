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
    
    let reuseId = "tileCollectionViewCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var refresh = UIRefreshControl()
    var fullScreenImgView: UIImageView = UIImageView()

    override public func viewDidLoad() {
        super.viewDidLoad()

             // Do any additional setup after loading the view, typically from a nib.
        self.title = "Main Feed"
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
        Refresh()
    }
    
    override public func viewWillAppear(animated: Bool) {        
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        refresh.beginRefreshing()
        Refresh()
    }
    
    func Refresh()
    {
        Helper.RestMainFeedRequest() {
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

    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tiles.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TileCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as TileCollectionViewCell
        
        cell.setup(tiles[indexPath.row].tile, img: tiles[indexPath.row].photo)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        Helper.UrlToImage(tiles[indexPath.row].tile.Photo!) {
            Photo in
            self.tiles[indexPath.row].photo = Photo
        }
        
        let imageW = tiles[indexPath.row].photo.size.width
        let imageH = tiles[indexPath.row].photo.size.height
        println("width: \(imageW), height: \(imageH)")
        
        let screenW = ceil(self.view.frame.width / 2.15)
        let screenH = ceil((screenW * imageH) / imageW)
        
        return CGSizeMake(screenW, screenH)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        return UICollectionReusableView()
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //collectionView.collectionViewLayout.invalidateLayout()
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TileCollectionViewCell
        println("index: \(indexPath.row) tapped: \(cell.frame.height)")
        
        let buttons = ["Cancel", "Pix", "Business"]
        
        // Create a new AlertView instance
        let alertView = CustomIOS7AlertView()
        
        // Set the button titles array
        alertView.buttonTitles = buttons
        
        // Set a custom container view
        alertView.containerView = createContainerView(cell, img: tiles[indexPath.row].photo)
        
        // Set self as the delegate
        alertView.delegate = self
        
        // Or, use a closure
        alertView.onButtonTouchUpInside = { (alertView: CustomIOS7AlertView, buttonIndex: Int) -> Void in
            println("CLOSURE: Button '\(buttons[buttonIndex])' touched")
        }
        
        // Show time!
        alertView.show()
    }
    
    // Handle button touches
    func customIOS7AlertViewButtonTouchUpInside(alertView: CustomIOS7AlertView, buttonIndex: Int) {
        //println("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        alertView.close()
    }
    
    // Create a custom container view
    func createContainerView(cell: UICollectionViewCell, img: UIImage) -> UIView {
        var containerView = UIView(frame: CGRectMake(0, 0, cell.frame.width * 2, cell.frame.height * 2))
        containerView.autoresizesSubviews = true
        containerView.contentMode = .ScaleAspectFit
        containerView.autoresizingMask = .FlexibleHeight
        
        var ivFullScreen = UIImageView()
        ivFullScreen.frame = CGRectMake(0, 0, containerView.frame.width, containerView.frame.height)
        ivFullScreen.center = CGPoint(x: containerView.frame.width / 2, y: containerView.frame.height / 2)
        ivFullScreen.autoresizesSubviews = true
        ivFullScreen.contentMode = .ScaleAspectFit
        ivFullScreen.autoresizingMask = .FlexibleHeight
        ivFullScreen.image = img
        
        containerView.addSubview(ivFullScreen)
        return containerView
    }
}
