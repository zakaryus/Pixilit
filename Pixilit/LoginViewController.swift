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
    }
    
    @IBAction func createAccountTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("GoRegister", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
           self.view.backgroundColor = HelperTransformations.BackgroundColor()
        self.inusername.delegate = self;
        self.inpassword.delegate = self;
        self.facebookButton.center = self.view.center;
        self.facebookButton.delegate = self;
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
                HelperLogin.Login(nil, encryptedPass: nil, vc: self, handler: HelperLogin.facebookLoginHelper)
                LoginSucceeded()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        println(User.Uid)
    }//end FBlogin button
    
    
    @IBAction func ContinueAnon(sender: AnyObject) {
        self.performSegueWithIdentifier("GoHome", sender: self)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton)
    {
        FBSDKLoginManager().logOut()
        User.Logout()
    }
    
    @IBAction func signinTapped(sender: UIButton) {
        if ( inusername.text == "" || inpassword.text == "" ){
            
            HelperLogin.LoginFailed(self)
        }
        else
        {
            var encrypted = MyCrypt.encryptString(inpassword.text)
            inpassword.text = "nothing to see here!"
            inpassword.text = ""
            if HelperLogin.Login(inusername.text, encryptedPass: encrypted, vc: self, handler: HelperLogin.signinLoginHelper) {
                LoginSucceeded()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
        
    func LoginSucceeded()
    {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Welcome, \(User.Username)"
        alertView.delegate = self
        
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false;
    }
}
