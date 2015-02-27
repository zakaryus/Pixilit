//
//  MyTabBarController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 2/27/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKIT

class MyTabBarController: UIViewController {
    @IBOutlet var tabBarButtons: Array<UIButton>!
    var currentViewController: UIViewController?
    @IBOutlet var placeholderView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if(tabBarButtons.count > 0) {
            performSegueWithIdentifier("BusinessListSegue", sender: tabBarButtons[0])
        }
    
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let availableIdentifiers = ["BusinessListSegue", "UserPageSegue", "UserLoginSegue", "NewspageSegue"]
        
        if(contains(availableIdentifiers, segue.identifier!)) {
            
            for btn in tabBarButtons {
                btn.selected = false
            }
            
            let senderBtn = sender as UIButton
            senderBtn.selected = true
        }
    }

}
