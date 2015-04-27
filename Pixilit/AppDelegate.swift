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
            //            var tabBarItem2 = tabBar.items[1]
            //         var tabBarItem3 = tabBar.items[2]
            //            var tabBarItem4 = tabBar.items[3]
            //
            //  tabBarItem1.title = "Main Feed"
            //            tabBarItem2.title = "Businesses"
            //            tabBarItem3.title = "Account"
            //            tabBarItem4.title = "Settings"
            // tabBarItem1.image = UIImage(named: "Slice 1-2.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            //  tabBarItem1.selectedImage = UIImage(named: "Slice 1-2.png")
            
            tabBar.tintColor = UIColor.whiteColor()
            
            //      tabBarItem1.image = UIImage(named: "Slice 1-2.png")
            // [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"home_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home.png"]];
            ////  [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"maps_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"maps.png"]];
            /// [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"myplan_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"myplan.png"]];
            /// [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"settings_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"settings.png"]];
            
            
            // Change the tab bar background
            // UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
            // [[UITabBar appearance] setBackgroundImage:tabBarBackground];
            //  [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selected.png"]];
            ///////////     tabBar.backgroundColor = UIColor(red: 132/255, green: 216/255, blue: 203/255, alpha: 1)
            tabBar.selectionIndicatorImage = getImageWithColor(UIColor(red: 0, green: 172/255, blue: 146/255, alpha: 1), size: CGSize(width:  rootcontroller.view.frame.width / 4, height: 49))
            // Change the title color of tab bar items
            
            
            
            //            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            //            [UIColor whiteColor], UITextAttributeTextColor,
            //            nil] forState:UIControlStateNormal];
            //            UIColor *titleHighlightedColor = [UIColor colorWithRed:153/255.0 green:192/255.0 blue:48/255.0 alpha:1.0];
            //            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            //            titleHighlightedColor, UITextAttributeTextColor,
            //            nil] forState:UIControlStateHighlighted];
            
        }
        
        
    return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
       // return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
       User.SetAnonymous()
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
}

