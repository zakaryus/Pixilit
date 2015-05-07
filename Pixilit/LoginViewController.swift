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

    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    override func viewWillAppear(animated: Bool) {
        println(User.Username)
        
        if User.Role != AccountType.Anonymous {
            performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
        }
    }
    
    @IBAction func createAccountTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("CreateAccountSegue", sender: "CreateAccountSegue")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inusername.delegate = self;
        self.inpassword.delegate = self;
        self.facebookButton.delegate = self;
        self.facebookButton.center = self.view.center;
        
//      if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//            HelperREST.RestFacebook(FBSDKAccessToken.currentAccessToken().tokenString)
//            self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
//        }
//        else
//        {
//            //println("ARE YOU EVER IN THE ELSE")
//            let loginView : FBSDKLoginButton = facebookButton
//            self.view.addSubview(loginView)
//            loginView.center = self.view.center
//            loginView.readPermissions = ["public_profile", "email"]
//            loginView.delegate = self
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(fbLoginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
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
                Login(facebookLoginHelper)
            }
        }
        println(User.Uid)
    }//end FBlogin button
    
    func facebookLoginHelper() -> JSON {
        var accessToken = "{\"access_token\":\"\(FBSDKAccessToken.currentAccessToken().tokenString )\"}"
        var json = HelperREST.RestRequest(Config.RestFacebookConnect, content: accessToken, method: HelperREST.HTTPMethod.Post, headerValues: nil)
        //maybe put NSUserDefaults stuff here
        NSUserDefaults.standardUserDefaults().setObject(FBSDKAccessToken.currentAccessToken().tokenString, forKey: "facebookToken")
        return json
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton)
    {
        FBSDKLoginManager().logOut()
        User.Logout()
    }
    
    @IBAction func signinTapped(sender: UIButton) {
        if ( inusername.text == "" || inpassword.text == "" ){
            
            LoginFailed()
        }
        else
        {
        Login(signinLoginHelper)
        }
    }
    
    func Login(handler: () -> JSON) {
        
      
            
            var json : JSON!
            var networkissues: Bool = false
            
            // GET TOKEN
            json = HelperREST.RestRequest(Config.RestUserToken, content: nil, method: HelperREST.HTTPMethod.Post, headerValues: nil)
            networkissues = NilJsonHandler(json, handler: UserToken)
            if networkissues { return }
            
            // SYSTEM CONNECT
            json = HelperREST.RestRequest(Config.RestSystemConnect, content: nil, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
            networkissues = NilJsonHandler(json, handler: SystemConnect)
            if networkissues { return }
            
            var uid = json["user"]["uid"].string!
            
            if uid == "0" //NO SESSION - Log in
            {
                json = handler()
                println(json)
                var name: String? = nil
                if let tkn = json["token"].string {
                    networkissues = NilJsonHandler(json, handler: TokenSession)
                    if networkissues { return }
                  //  println(json)
                    name = json["user"]["name"].string
                }
                
                if (name == nil) {
                    LoginFailed()
                    return
                }
            }
            
            User.Setup(json)

            
            LoginSucceeded()
            
            self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
        
    }
    
    func signinLoginHelper() -> JSON {
        var loginurl:NSURL = NSURL(string: Config.RestUserLogin)!
        var encrypted = MyCrypt.encryptString(inpassword.text)
       // println(encrypted)
        var loginString = "{\"username\":\"\(inusername.text)\", \"password\":\"\(encrypted)\"}"
        inpassword.text = "nothing to see here"
        inpassword.text = ""
        NSUserDefaults.standardUserDefaults().setObject(inusername.text, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(encrypted, forKey: "encryptedPassword")
       // println(loginString)
        var json = HelperREST.RestRequest(Config.RestUserLogin, content: loginString, method: HelperREST.HTTPMethod.Post, headerValues: nil)
        return json
    }
    
    func NilJsonHandler(json: JSON, handler: (JSON) -> ()) -> Bool {
        if json != nil {
            handler(json)
            return false
        }
        else {
            NetworkIssues()
            return true
        }
    }
    
    func UserToken(json: JSON) {
     
        var token = json["token"].string!
        User.setToken(token)
    }
    
    func SystemConnect(json: JSON) {
        var sessname = json["session_name"].string!
        var sessid = json["sessid"].string!
        User.SetSession(sessname, sessid: sessid)
    }
    
    func TokenSession(json: JSON) {
   //     println(json)
        var sessname = json["session_name"].string!
        var sessid = json["sessid"].string!
        User.SetSession(sessname, sessid: sessid)
        var token = json["token"].string!
        User.setToken(token)
    }
    
    func LoginFailed()
    {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Login Failed"
        alertView.message = "Re-enter username and password"
        alertView.delegate = self
        
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func LoginSucceeded()
    {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Welcome, \(User.Username)"
        alertView.delegate = self
        
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func NetworkIssues()
    {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Network Issues"
        alertView.message = "Please try again later"
        alertView.delegate = self
        
        alertView.addButtonWithTitle("OK")
        alertView.show()
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
}
