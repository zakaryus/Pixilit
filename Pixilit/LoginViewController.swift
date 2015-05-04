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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinTapped(sender: UIButton) {
        
        if ( inusername.text == "" || inpassword.text == "" ){
            
            LoginFailed()
        }
        else {
            
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

            
            var loginurl:NSURL = NSURL(string: Config.RestUserLogin)!
            var encrypted = MyCrypt.encryptString(inpassword.text)
            println(encrypted)
            var loginString = "{\"username\":\"\(inusername.text)\", \"password\":\"\(encrypted)\"}"
            inpassword.text = "nothing to see here"
            inpassword.text = ""

            var uid = json["user"]["uid"].string!
          
            
            if uid == "0" //NO SESSION - Log in
            {
                println(loginString)
                json = HelperREST.RestRequest(Config.RestUserLogin, content: loginString, method: HelperREST.HTTPMethod.Post, headerValues: nil)
                networkissues = NilJsonHandler(json, handler: LoginHelper)
                if networkissues { return }
                println(json)
                var name = json["user"]["name"].string
                
                if (name == nil) {
                    LoginFailed()
                    return
                }
            }
            
            User.Setup(json)
            
            LoginSucceeded()
           
            self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
        }
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
        println("usertoken: \(json)")
        var token = json["token"].string!
        User.setToken(token)
    }
    
    func SystemConnect(json: JSON) {
        var sessname = json["session_name"].string!
        var sessid = json["sessid"].string!
        User.SetSession(sessname, sessid: sessid)
    }
    
    func LoginHelper(json: JSON) {
        println(json)
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
    
    func showAlert(title: NSString, message: NSString) {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = title as String
        alertView.message = message as String
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
