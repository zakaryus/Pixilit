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
        var username:NSString = inusername.text
        var password:NSString = inpassword.text
        
        if ( username.isEqualToString("") || password.isEqualToString("") ){
            
            showAlert("Login Failed", message: "Re-enter username and password")

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
                        showAlert("Login Failed", message: "Re-enter username and password")
                    }
                  
                    else {
                        showAlert("Welcome, \(name!)", message: "")
                        User.userSetup(userjson)
                        HelperREST.RestBasicProfile(User.Uid)
                    

                        self.performSegueWithIdentifier("LoginSuccess", sender: "LoginSuccess")
                   
                    }
            }
            else {
                showAlert("Network Issues", message: "Please try again later")
            }
        }

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
