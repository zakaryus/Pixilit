//
//  LoginViewController.swift
//  Pixilit
//
//  Created by Michael G on 2/8/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    @IBOutlet weak var inusername: UITextField!
    @IBOutlet weak var inpassword: UITextField!
    var facebookToken = ""
    
    
  
    @IBOutlet var fbLoginButton: FBSDKLoginButton!
    
    override func viewWillAppear(animated: Bool) {
        ////println("User name in viewWillAppear is "+User.Username)
        ////println("User UID in viewWillAppear is "+User.Uid)
       
        if User.Role != AccountType.Anonymous {
       
            performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
        }
       
    }

    
    @IBAction func createAccountTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("CreateAccountSegue", sender: "CreateAccountSegue")
    }

    
    @IBAction func facebookAction(sender: AnyObject) {


        
    }
    
    func loginButton(fbLoginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {

                
//        if (FBSDKAccessToken.currentAccessToken().tokenString != nil)
//        {
//            println("ACCESS TOKEN IS " + FBSDKAccessToken.currentAccessToken().tokenString)
//            var accessToken =  FBSDKAccessToken.currentAccessToken().tokenString
//            println("accessToke is " + accessToken)
//            let urlPath = Config.RestFacebookConnect
//            let url: NSURL = NSURL(string: urlPath)!
//            
//            var post:NSString = "{\"access_token\":\"\(accessToken)\"}"
//            
//            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
//            var postLength:NSString = String(postData.length )
//            var reponseError: NSError?
//            var response: NSURLResponse?
//            
//            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//            request.HTTPMethod = "POST"
//            request.HTTPBody = postData
//            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//            var data: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
//            
//            if (data != nil)
//            {
//                var json = JSON(data: data!)
//                User.userSetup(json)
//                HelperREST.RestBasicProfile(User.Uid)
//                println("json inside fb button \(json)")
//                println("User name is " + User.Username)
//                println("User id is " + User.Uid)
//                self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
//            }
//                
//            else
//            {
//                println("loginData is nil in RestFacebook")
//            }
//            
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                println("ACCESS TOKEN IS " + FBSDKAccessToken.currentAccessToken().tokenString)
                            var accessToken =  FBSDKAccessToken.currentAccessToken().tokenString
                            println("accessToke is " + accessToken)
                            let urlPath = Config.RestFacebookConnect
                            let url: NSURL = NSURL(string: urlPath)!
                
                            var post:NSString = "{\"access_token\":\"\(accessToken)\"}"
                
                            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                            var postLength:NSString = String(postData.length )
                            var reponseError: NSError?
                            var response: NSURLResponse?
                
                            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                            request.HTTPMethod = "POST"
                            request.HTTPBody = postData
                            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            request.setValue("application/json", forHTTPHeaderField: "Accept")
                            var data: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
                
                            if (data != nil)
                            {
                                var json = JSON(data: data!)
                                User.userSetup(json)
                                HelperREST.RestBasicProfile(User.Uid)
                                println("json inside fb button \(json)")
                                println("User name is " + User.Username)
                                println("User id is " + User.Uid)
                                self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
                            }

            }
        }

            
            
//        }//end big if
//            
//        else
//        {
//            //println("BUTTON SAYS NO TOKEN")
//        }
        

        
    }//end FBlogin button
    
 
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton)
    {
     
       FBSDKLoginManager().logOut()
        ////println("facebook loggeout")
        User.Logout()
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        self.inusername.delegate = self;
        self.inpassword.delegate = self;
        self.fbLoginButton.center = self.view.center;
        self.fbLoginButton.delegate = self;
       
        

        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            HelperREST.RestFacebook(FBSDKAccessToken.currentAccessToken().tokenString)
            self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
        }
        else
        {
            ////println("ARE YOU EVER IN THE ELSE")
            let loginView : FBSDKLoginButton = fbLoginButton
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email"]
            loginView.delegate = self
        }
   
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
            
                    var loginurl:NSURL = NSURL(string: Config.RestUserLogin)!
                    var encrypted = MyCrypt.encryptString(password as String)
            ////println(encrypted)
                    password = "nothing to see here"
            
                    var loginpost:NSString = "{\"username\":\"\(username)\",\"password\":\"\(MyCrypt.key + encrypted)\"}"
              ////println(loginpost)
                    var loginpostData:NSData = loginpost.dataUsingEncoding(NSASCIIStringEncoding)!
                    var loginpostLength:NSString = String( loginpostData.length )
                    var reponseError: NSError?
                    var response: NSURLResponse?
            
                    var loginrequest:NSMutableURLRequest = NSMutableURLRequest(URL: loginurl)
                    loginrequest.HTTPMethod = "POST"
                    loginrequest.HTTPBody = loginpostData
                    loginrequest.setValue(loginpostLength as String, forHTTPHeaderField: "Content-Length")
                    loginrequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    loginrequest.setValue("application/json", forHTTPHeaderField: "Accept")
                    var loginData: NSData? = NSURLConnection.sendSynchronousRequest(loginrequest, returningResponse:&response, error:&reponseError)
            
            
            if(loginData != nil) {
                    var userjson = JSON(data: loginData!)
                    var name = userjson["user"]["name"].string
            
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
                        println("userjson is: ")
                        println(userjson)
                        User.userSetup(userjson)
                        HelperREST.RestBasicProfile(User.Uid)
                    

                        self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
                   
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false;
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var segueType = sender as! String
    
        if segueType == "LoginSuccess"
        {
        var uvc = segue.destinationViewController as! UserViewController
        }
        else if segueType == "CreateAccountSegue"
        {
            var uvc = segue.destinationViewController as! CreateAccountViewController
        }
        
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
   
}
