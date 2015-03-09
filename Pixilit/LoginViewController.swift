//
//  LoginViewController.swift
//  Pixilit
//
//  Created by Michael G on 2/8/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var inusername: UITextField!
    @IBOutlet weak var inpassword: UITextField!

    override func viewWillAppear(animated: Bool) {
        println(User.Username)
        
        if User.Role != AccountType.Anonymous {
            performSegueWithIdentifier("LoginSuccess", sender: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinTapped(sender: UIButton) {
        var username:NSString = inusername.text
        var password:NSString = inpassword.text
        
        if ( username.isEqualToString("") || password.isEqualToString("") ){
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Login Failed"
            alertView.message = "Re-enter username and password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
                    var loginurl:NSURL = NSURL(string: "http://pixilit.com/rest/user/login")!
                    
                    var loginpost:NSString = "{\"username\":\"\(username)\",\"password\":\"\(password)\"}"
                 
                    var loginpostData:NSData = loginpost.dataUsingEncoding(NSASCIIStringEncoding)!
                    var loginpostLength:NSString = String( loginpostData.length )
                    var reponseError: NSError?
                    var response: NSURLResponse?
            
                    var loginrequest:NSMutableURLRequest = NSMutableURLRequest(URL: loginurl)
                    loginrequest.HTTPMethod = "POST"
                    loginrequest.HTTPBody = loginpostData
                    loginrequest.setValue(loginpostLength, forHTTPHeaderField: "Content-Length")
                    loginrequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    loginrequest.setValue("application/json", forHTTPHeaderField: "Accept")
                    var loginData: NSData? = NSURLConnection.sendSynchronousRequest(loginrequest, returningResponse:&response, error:&reponseError)
            
            
            if(loginData != nil) {
                    var userjson = JSON(data: loginData!)
                    var name = userjson["user"]["name"].string?
            
                    if (name == nil) {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Login Failed"
                        alertView.message = "Re-enter username and password"
                        alertView.delegate = self
                        
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                  
                    else {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Welcome, \(name!)"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()

                        User.userSetup(userjson)

                        self.performSegueWithIdentifier("LoginSuccess", sender: "")
                   
                    }
            }
            else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Network Issues"
                alertView.message = "Please try again later"
                alertView.delegate = self
                
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var uvc = segue.destinationViewController as UserViewController
    }
   
}
