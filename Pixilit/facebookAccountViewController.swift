//
//  CreateAccountViewController.swift
//  Pixilit
//
//  Created by SPT Pixilit on 4/10/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class facebookAccountViewController: UIViewController, UIWebViewDelegate {
    
  //  @IBOutlet weak var wvAccountCreation: UIWebView!
  //  @IBOutlet weak var scAccountSelection: UISegmentedControl!
    var URL : String = ""
    override func viewDidLoad(){
        
        super.viewDidLoad()
        URL = Config.facebookConnectURL
        let U = NSURL(string: URL)
        let req = NSURLRequest(URL: U!)
      //  wvAccountCreation.loadRequest(req)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func SelectionChanged(sender: AnyObject) {
//        if scAccountSelection.selectedSegmentIndex == 0{
//            URL = Config.UserRegistrationURL
//        }
//        else
//        {
//            URL = Config.BusinessRegistrationURL
//        }
//        
//        let U = NSURL(string: URL)
//        let req = NSURLRequest(URL: U!)
//      //  wvAccountCreation.loadRequest(req)
//        
//    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        if let currenturl = webView.request?.URL!.absoluteString {
            println(currenturl)
            
            if currenturl != Config.UserRegistrationURL && currenturl != Config.BusinessRegistrationURL && currenturl != "webViewDidFinishLoad:" {
                if let tbc = self.tabBarController {
                  //  SelectionChanged("")
                    tbc.selectedIndex = 0
                }
            }
        }
        //println(webView.request?.URL.absoluteString)
    }
    
}