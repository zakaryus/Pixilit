//
//  HelperUtility.swift
//  Pixilit
//
//  Created by SPT Pixilit on 6/1/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import Foundation
struct HelperUtility{
    
    
    static func infoAlert(userMessage: String, businessMessage: String, vc: UIViewController) {
        var msg: String = ""
        if User.Role == AccountType.Business {
            msg = businessMessage
        } else {
            msg = userMessage
        }
        
        var ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        var infoAlert = UIAlertController(title: "How To", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        infoAlert.addAction(ok)
        vc.presentViewController(infoAlert, animated: true, completion: nil)

    }
}