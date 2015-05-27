//
//  MoreBusinessInfoController.swift
//  Pixilit
//
//  Created by Giang Bui on 27/05/2015.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

class MoreBusinessInfoController: UIViewController {
    
    
    @IBOutlet weak var businessTitleLabel: UILabel!
    @IBOutlet var MoreBusinessInfo: UIView!
    //hide status bar-->carrier and battery
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
        //****************************
    //let reuseId = "businessPhotoCollectionViewCell"
    //let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    //****************************
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    
    func SetBusinessToVC(business: Business)
    {
      //  if let title = business.Title {
            //self.businessName.text = title
            //  self.businessName.backgroundColor = mintyForest
            //self.businessNavBar.title = title
      //  }
        
//        var thoroughfare: String
//        if let _thoroughfare = business.Thoroughfare {
//            thoroughfare = _thoroughfare
//        }
//        
//        var locality: String = ""
//        if let _locality = business.Locality {
//            locality = _locality
//        }
//        
//        var administrativearea: String = ""
//        if let _administrativearea = business.AdministrativeArea {
//            administrativearea = _administrativearea
//        }
//        
//        var postalcode: String = ""
//        if let _postalcode = business.PostalCode {
//            postalcode = _postalcode
//        }
//        
//        if locality != "" && administrativearea != "" && postalcode != "" {
//            //self.businessLocalityAdminZip.text = "\(locality), \(administrativearea) \(postalcode)"
//            // self.businessLocalityAdminZip.backgroundColor = mintyForest
//        }
//        
//        if let phone = business.Phone {
//            //self.businessPhone.text = phone
//            // self.businessPhone.backgroundColor = mintyForest
//        }
//        
//        if let email = business.Email {
//            //self.businessEmail.text = email
//            // self.businessEmail.backgroundColor = mintyForest
//        }
//        
//        if let website = business.Website {
//            // self.businessWebsite.text = website
//            //self.businessWebsite.backgroundColor = mintyForest
//        }
//        
//        //self.Hours = [String]()
//        
//        if let description = business.Description {
//            // self.businessDescription.text = description
//            // self.businessDescription.backgroundColor = self.mintyForest
//        }
//        
//        if let logo = business.Logo {
//            HelperURLs.UrlToImage(logo)
//                {
//                    Image in
//                    //      self.businessLogo.image = Image
//                    //      self.businessLogo.backgroundColor = self.mintyForest
//            }
//        }
//        
//        SetMintyForestBackground()
    }
    

    
         override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
      //  var tpvc = segue.destinationViewController as! TilePopupViewController
       // var index = sender as! Int
       // tpvc.SelectedTile = tiles[index].tile
       // tpvc.SelectedImage = tiles[index].photo
        
        //tpvc.disablePictureInteraction()
    }
    
}

