//
//  AboutViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/14/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController : UIViewController{
  
    @IBOutlet weak var tbBody: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var AboutModel: About?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbBody.center = self.view.center
        self.lblTitle.center = self.view.center
        
        var json = HelperREST.RestRequest(Config.RestAboutPixilit, content : ""  , method : HelperREST.HTTPMethod.Get, headerValues : nil)
        AboutModel = About(json: json[0])
        SetAbout(AboutModel!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func SetAbout(about: About)
    {
        lblTitle.text = about.Title
        tbBody.text = about.Body
    }
}