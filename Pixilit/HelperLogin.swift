//
//  HelperLogin.swift
//  Pixilit
//
//  Created by SPT Pixilit on 5/7/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation
struct HelperLogin {
    
    static func facebookLoginHelper(username: String?, encryptedPass: String?) -> JSON {
        var accessToken: String!
        if encryptedPass != nil {
            accessToken = "{\"access_token\":\"\(encryptedPass)\"}"
            NSUserDefaults.standardUserDefaults().setObject(encryptedPass, forKey: "facebookToken")
        } else {
            accessToken = "{\"access_token\":\"\(FBSDKAccessToken.currentAccessToken().tokenString)\"}"
            NSUserDefaults.standardUserDefaults().setObject(FBSDKAccessToken.currentAccessToken().tokenString, forKey: "facebookToken")
        }
        
        var json = HelperREST.RestRequest(Config.RestFacebookConnect, content: accessToken, method: HelperREST.HTTPMethod.Post, headerValues: nil)        
        return json
            
    }
    
    static func Login(username: String?, encryptedPass: String?, vc: UIViewController, handler: (String?, String?) -> JSON) {
        
        var json : JSON!
        var networkissues: Bool = false
        
        // GET TOKEN
        json = HelperREST.RestRequest(Config.RestUserToken, content: nil, method: HelperREST.HTTPMethod.Post, headerValues: nil)
        networkissues = NilJsonHandler(vc, json: json, handler: UserToken)
        if networkissues { return }
        
        // SYSTEM CONNECT
        json = HelperREST.RestRequest(Config.RestSystemConnect, content: nil, method: HelperREST.HTTPMethod.Post, headerValues: [("X-CSRF-Token",User.Token)])
        networkissues = NilJsonHandler(vc, json: json, handler: SystemConnect)
        if networkissues { return }
        
        var uid = json["user"]["uid"].string!
        
        if uid == "0" //NO SESSION - Log in
        {
            json = handler(username, encryptedPass)
            println(json)
            var name: String? = nil
            if let tkn = json["token"].string {
                networkissues = NilJsonHandler(vc, json: json, handler: TokenSession)
                if networkissues { return }
                //  println(json)
                name = json["user"]["name"].string
            }
            
            if (name == nil) {
                LoginFailed(vc)
                return
            }
        }
        
        User.Setup(json)
    }
    
    static func signinLoginHelper(username: String?, encryptedPass: String?) -> JSON {
        var loginurl:NSURL = NSURL(string: Config.RestUserLogin)!
        var loginString = "{\"username\":\"\(username)\", \"password\":\"\(encryptedPass)\"}"
        
    
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(encryptedPass, forKey: "encryptedPassword")

        var json = HelperREST.RestRequest(Config.RestUserLogin, content: loginString, method: HelperREST.HTTPMethod.Post, headerValues: nil)
        return json
    }
    
    static func NilJsonHandler(vc: UIViewController, json: JSON, handler: (JSON) -> ()) -> Bool {
        if json != nil {
            handler(json)
            return false
        }
        else {
            NetworkIssues(vc)
            return true
        }
    }
    
    static func UserToken(json: JSON) {
        
        var token = json["token"].string!
        User.setToken(token)
    }
    
    static func SystemConnect(json: JSON) {
        var sessname = json["session_name"].string!
        var sessid = json["sessid"].string!
        User.SetSession(sessname, sessid: sessid)
    }
    
    static func TokenSession(json: JSON) {
        //     println(json)
        var sessname = json["session_name"].string!
        var sessid = json["sessid"].string!
        User.SetSession(sessname, sessid: sessid)
        var token = json["token"].string!
        User.setToken(token)
    }
    
    static func LoginFailed(vc: UIViewController)
    {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Login Failed"
        alertView.message = "Re-enter username and password"
        alertView.delegate = vc
        
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    static func NetworkIssues(vc: UIViewController)
    {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Network Issues"
        alertView.message = "Please try again later"
        alertView.delegate = vc
        
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    
}