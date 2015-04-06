//
//  PixilitTests.swift
//  PixilitTests
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit
import XCTest


class PixilitTests: XCTestCase {

    var mainFeed : MainFeedViewController = MainFeedViewController()
    var businessList : BusinessListViewController = BusinessListViewController()
    var businessView : BusinessViewController = BusinessViewController()
    
    override func setUp() {
        super.setUp()
        //let mainNewsFeed = MainFeedViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testMainFeedNotNil() {
        XCTAssertNotNil(mainFeed, "view did not load")
        //User.SetAnonymous()
        //XCTAssert(User.Username == "Anonymous", "everything went better than expected")
    }
    
    func testBusinessListNotNil() {
        XCTAssertNotNil(businessList, "view did not load")
        //User.SetAnonymous()
        //XCTAssert(User.Username == "Anonymous", "everything went better than expected")
    }
    
    func testBusinessViewNotNil() {
        XCTAssertNotNil(businessView, "view did not load")
        //User.SetAnonymous()
        //XCTAssert(User.Username == "Anonymous", "everything went better than expected")
    }


    
    func testMainFeedJsonRequest() {
        var completionHandlerRan = false
        Helper.RestMainFeedRequest() {
            Tiles in
            println(Tiles.count)
            XCTAssert(Tiles.count > 0, "No pictures were grabbed")
            completionHandlerRan = true
        }
        println("TEST TEST TEST")
        XCTAssert(completionHandlerRan, "Completion handler did not run")
        
    }
    
    func testBusinessListJson(){
        var completionHandlerRan = false
        Helper.RestBusinessesRequest() {
            Businesses in
            println("Buisinesses: \(Businesses.count)")
            XCTAssert(Businesses.count > 0, "No businesses were grabbed from the website")
            completionHandlerRan = true
        }
        println("Buisinesses: \(3)")
        XCTAssert(completionHandlerRan, "Completion handler did not run")
    }
    
    /*func testalwaysFails() {
        XCTAssert(false, "this will always fail")
    }*/
}
