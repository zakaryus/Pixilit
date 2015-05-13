//
//  AppDelegate.swift
//  Pixilit
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootcontroller = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        if self.window != nil {
            self.window!.rootViewController = rootcontroller
            var tabBar : UITabBar = rootcontroller.tabBar
            var tabBarItem1 : UITabBarItem = tabBar.items![0] as! UITabBarItem
         //   tabBar.selectedImageTintColor = UIColor.whiteColor()
             tabBar.selectionIndicatorImage = getImageWithColor(UIColor(red: 0, green: 172/255, blue: 146/255, alpha: 1), size: CGSize(width:  rootcontroller.view.frame.width / 4, height: 49))
           
        }
        
        if let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String, let encryptedPassword = NSUserDefaults.standardUserDefaults().objectForKey("encryptedPassword") as? String
        {
            
            //login
            if !HelperLogin.Login(username, encryptedPass: encryptedPassword, vc: self.window!.rootViewController!, handler: HelperLogin.signinLoginHelper) {
                User.SetAnonymous()
            }
            
        }
            
        else if let facebookToken = NSUserDefaults.standardUserDefaults().objectForKey("facebookToken") as? String
        {
            
            //login
            if !HelperLogin.Login("", encryptedPass: facebookToken, vc: self.window!.rootViewController!, handler: HelperLogin.facebookLoginHelper) {
                User.SetAnonymous()
            }
        }
            
        else {User.SetAnonymous()}

        
        

          return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        var rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(application: UIApplication) {
            // FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }


}

