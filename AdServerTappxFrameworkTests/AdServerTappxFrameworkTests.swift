//
//  AdServerTappxFrameworkTests.swift
//  AdServerTappxFrameworkTests
//
//  Created by David Alarcon on 21/10/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import XCTest
@testable import AdServerTappxFramework

class AdServerTappxFrameworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testInitFramework() {
        let grettings = Greetings()
        grettings.initialize()
        
        guard let age = AdServerTappxFramework.sharedInstance.settings?.age else {
            XCTFail("Not Age set")
            return
        }
        
        XCTAssertNotEqual("44", age, "Age is different")
        
        
    }
    
    
    func testInterstitial() {
        let testNetwork = self.expectation(description: "Test interstitial")
        
        
        DataManager.testNetwork {
            testNetwork.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { handler in
            
        }
    }
    
    func testClient() {
        let client = Greetings()
        client.sayHello()
        print("Adapter: \(client.adapterId)")
    }
    
}
