//
//  PixilitTests.swift
//  PixilitTests
//
//  Created by Zak Steele MBP on 1/28/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

import UIKit
import XCTest
import Pixilit

class PixilitTests: XCTestCase {

    var mainFeed : MainFeedViewController = MainFeedViewController()

    
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
    
//    func testMainFeedNotNil() {
//        XCTAssertNotNil(mainFeed, "view did not load")
//        //User.SetAnonymous()
//        //XCTAssert(User.Username == "Anonymous", "everything went better than expected")
//    }
//    
//    func testMainFeedJsonRequest() {
//        var passed = false;
//        HelperREST.RestMainFeedRequest() {
//            Tiles in
//            println("Number of Tiles:\(Tiles.count)")
//            passed = Tiles.count > 0
//        }
//        XCTAssert(passed, "No pictures were grabbed")
//    }
//    
//    func testBusinessListJson(){
//        HelperREST.RestBusinessesRequest() {
//            Businesses in
//            println("Number of Businesses:\(Businesses.count)")
//            XCTAssert(Businesses.count > 0, "No businesses were grabbed from the website")
//        }
//        println("Test Passed")
//    }
    
    func testUserAnonymous() {
        User.SetAnonymous()
        XCTAssert(User.Uid == "-1", "Uid is not -1")
        
    }
    
    func testUserLogin() {
        
        let str = "{\"user\":{\"status\":\"1\",\"theme\":\"\",\"roles\":{\"2\":\"authenticateduser\",\"5\":\"Basic\"},\"uid\":\"13\",\"profile\":{\"all\":{\"field_user_regions\":{\"und\":[{\"tid\":\"3760\"},{\"tid\":\"3487\"},{\"tid\":\"3487\"},{\"tid\":\"3405\"},{\"tid\":\"3406\"},{\"tid\":\"3332\"},{\"tid\":\"4233\"}]},\"uid\":\"13\",\"rdf_mapping\":[],\"created\":\"1427929264\",\"label\":\"Basic\",\"type\":\"basic\",\"changed\":\"1429822098\",\"pid\":\"2\"},\"regions\":[{\"tid\":\"3760\"},{\"tid\":\"3487\"},{\"tid\":\"3487\"},{\"tid\":\"3405\"},{\"tid\":\"3406\"},{\"tid\":\"3332\"},{\"tid\":\"4233\"}]},\"access\":\"1431559688\",\"login\":1431729246,\"picture\":\"0\",\"signature_format\":\"filtered_html\",\"signature\":\"\",\"data\":{\"user_cancel_method\":\"user_cancel_block\",\"user_cancel_notify\":0},\"language\":\"\",\"created\":\"1427929264\",\"rdf_mapping\":{\"rdftype\":[\"sioc:UserAccount\"],\"name\":{\"predicates\":[\"foaf:name\"]},\"homepage\":{\"type\":\"rel\",\"predicates\":[\"foaf:page\"]}},\"timezone\":\"America\\/Los_Angeles\",\"name\":\"MichaelBasic\",\"mail\":\"michael.samwise@gmail.com\"},\"session_name\":\"SESSa32967f19460d2f5f4e04f02079cdc61\",\"sessid\":\"zrkxQ2Xv6Mf4l6-Lj9vCe8cEcnf9LMoN3KD_yuggF38\",\"token\":\"g5agyKbARcaluxLwH0-TqGKIis2T2nYSjXUgxQB46Yc\"}"
        
        var data : NSData = (str as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        var json : JSON = JSON(data)
        User.Setup(json)
        
        XCTAssert(User.Uid == "13", "User id is incorrect!")
    }
    
    /*func testalwaysFails() {
        XCTAssert(false, "this will always fail")
    }*/
}
