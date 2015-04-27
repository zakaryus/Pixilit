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
        println(User.Username)
       
        if User.Role != AccountType.Anonymous {
            performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
        }
       
    }

    
    @IBAction func createAccountTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("CreateAccountSegue", sender: "CreateAccountSegue")
    }

    
    @IBAction func facebookAction(sender: AnyObject) {
//        println("FACEBOOK ACTION CLICKED")
//        if(FBSDKAccessToken.currentAccessToken()  != nil)
//        {
//            println("yes token")
//        facebookToken += FBSDKAccessToken.currentAccessToken().tokenString
//                    HelperREST.RestFacebook(facebookToken)
//            //              self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
//        }
//        else
//        {
//
//        }
//     //  FBSDKLoginManager

        
    }
    
    func loginButton(fbLoginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        //facebookToken = ""
//        if(FBSDKAccessToken.currentAccessToken()  != nil)
//        {
//            println("yes token")
//        facebookToken += FBSDKAccessToken.currentAccessToken().tokenString //getting the facebook access token
//          HelperREST.RestFacebook(facebookToken)
        
           // HelperREST.RestFacebook(facebookToken)
    // self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
            
//            let urlPath = Config.RestFacebookConnect
//            let url: NSURL = NSURL(string: urlPath)!
//            
//            var post:NSString = "{\"access_token\":\"\(facebookToken)\"}"
//            println(post)
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
//            var json = JSON(data: data!)
//            var name = json["user"]["name"].string
//            println(json)
//            User.userSetup(json)
//            println("USEIJRISJDIJFIJSDF")
//            println(User.Uid)
//            
//            if(name != nil)
//            {
//            self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
//            }
//            else
//            {
//                println("something is wrong. name is nil in facebook login")
//            }
//            
  //    }
//        
//        
//  
        
        //fbLoginButton.readPermissions = ["public_profile", "email"]
        //var userName = result.valueForKey("email") as! NSString!
     //   println(userName)
       //  s var facebookUserName = returnUserData()
        //var facebookName = getFacebookUserData()
     // getFacebookUserData()
           //    println("facebook log in")
        
        
        if ((error) != nil)
        {
           println("THERE IS AN ERROR WITH FBLOGINBUTTON")
        }
        else if result.isCancelled {
            println("USER CANCELLED FB LOGIN")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
           // if result.grantedPermissions.contains("email")
           // {
                // Do work
           // }
            println("IN THE ELSE OF FB BUTTON")
           // HelperREST.RestFacebook(FBSDKAccessToken.currentAccessToken().tokenString)
           // self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
        }
        
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            HelperREST.RestFacebook(FBSDKAccessToken.currentAccessToken().tokenString)
            self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
        }
        

        
    }//end FBlogin button
    
 
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton)
    {
        facebookToken = ""
        println("facebook loggeout")
       // User.Logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inusername.delegate = self;
        self.inpassword.delegate = self;
       // fbLoginButton.center = self.view.center;
        //self.fbLoginButton.delegate = self;

        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            HelperREST.RestFacebook(FBSDKAccessToken.currentAccessToken().tokenString)
            self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
        }
        else
        {
            let loginView : FBSDKLoginButton = fbLoginButton
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    
    }
    
    
//    func getFacebookUserData()
//    {
//        
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "me", paramet"ers: nil)
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if ((error) != nil)
//            {
//                // Process error
//                println("Error: \(error)")
//            }
//            else
//            {
//                let facebookName = (result.valueForKey("name") as? String)!
//                let facebookID = (result.valueForKey("id") as? String)!
//               
//                print("name is  ")
//                println(facebookName)
//                User.facebookUsernameSet(facebookName)
//                User.facebookIDSet(facebookID)
//            
//               
//            }
//            
//        
//        }
//        )
//       
//
//    }
    
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
            println(encrypted)
                    password = "nothing to see here"
            
                    var loginpost:NSString = "{\"username\":\"\(username)\",\"password\":\"\(MyCrypt.key + encrypted)\"}"
              println(loginpost)
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

                        User.userSetup(userjson)

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
