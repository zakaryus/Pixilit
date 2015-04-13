//
//  NewsPageViewController.swift
//  Pixilit
//
//  Created by Steele, Zachary on 3/4/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit

class NewsPageViewController: UIViewController {

    @IBOutlet weak var Body: UITextView!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Title: UITextView!
    var newspage: NewsPage = NewsPage()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpPage(newspage)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    func setUpPage(newspage: NewsPage) {
        if let title = newspage.Title {
            self.Title.text = title
        }
        
        if let date = newspage.Date {
            self.Date.text = HelperStrings.NSDateToString(date)
        }
        
        if let body = newspage.Body {
            self.Body.text = body
        }
        
    }
}
