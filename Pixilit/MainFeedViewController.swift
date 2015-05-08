//
//  MainFeedViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/6/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

public class MainFeedViewController: UIViewController
{
    
    
    @IBOutlet weak var collectionView: PixilitCollectionView!
    
    var selectedTile: Tile = Tile()
    var refresh = UIRefreshControl()
    var selectedIndex = NSIndexPath()
    var hasLoggedIn = false
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.presentingViewController?.providesPresentationContextTransitionStyle = true
        self.presentingViewController?.definesPresentationContext = true
        
        refresh.addTarget(self, action: "Refresh", forControlEvents: .ValueChanged)
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        collectionView.insertSubview(refresh, aboveSubview: collectionView)

        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Main Feed"
 
    }
    
    
    override public func viewWillAppear(animated: Bool) {
        println(User.Uid)
        if hasLoggedIn == false && User.IsLoggedIn()
        {
            hasLoggedIn = true
            Refresh()
        }
        else if hasLoggedIn == true && !User.IsLoggedIn()
        {
            hasLoggedIn = false
            Refresh()
        }
        else if collectionView.tiles.count == 0 {
            Refresh()
        }
        
    }
    
    func Refresh() {
        
        refresh.beginRefreshing()
     //   HelperREST.RestRequest(Config.RestMainFeedJson, content: nil, method: HelperREST.HTTPMethod.Get, headerValues: nil)
  
        HelperREST.RestMainFeedRequest() {
            Tiles in

            self.collectionView.tiles = []
          
            for tile in Tiles {
                self.collectionView.tiles.append(tile: tile, photo: UIImage(), photoSize: CGSizeMake(0, 0), hasImage: false)
            }
            
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var tpvc = segue.destinationViewController as! TilePopupViewController
        var index = sender as! Int
        tpvc.SelectedTile = collectionView.tiles[index].tile
        tpvc.SelectedImage = collectionView.tiles[index].photo
    }
}
