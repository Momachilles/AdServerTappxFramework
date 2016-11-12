//
//  AdServerTappxFrameworkTestKeywordOne.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 11/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import XCTest

class AdServerTappxFrameworkTestKeywordOne: XCTestCase {
    
    var settings: Settings {
        var s = Settings()
        s.keywords = ["1"]
        return s
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testBannerDefault() {
//        let networkExpectation = self.expectation(description: "Test banner Default OKW 1")
//        
//        AdServerTappxFramework.sharedInstance.settings = self.settings
//        
//        DataManager.tappxBanner() {
//            print("Result: \($0)")
//            XCTAssertEqual($0.value(), "", "String should be no_fill")
//            networkExpectation.fulfill()
//        }
//        
//        self.waitForExpectations(timeout: 5) { handler in
//            
//        }
//    }
//    
//    func testBanner320x50() {
//        let networkExpectation = self.expectation(description: "Test banner 320x50 OKW 1")
//        
//        AdServerTappxFramework.sharedInstance.settings = self.settings
//        
//        DataManager.tappxBanner(withSize: .x320y50) {
//            print("Result: \($0)")
//            XCTAssertEqual($0.value(), "", "String should be no_fill")
//            networkExpectation.fulfill()
//        }
//        
//        self.waitForExpectations(timeout: 5) { handler in
//            
//        }
//    }
//    
//    func testBanner728x90() {
//        let networkExpectation = self.expectation(description: "Test banner 728x90 OKW 1")
//        
//        AdServerTappxFramework.sharedInstance.settings = self.settings
//        
//        DataManager.tappxBanner(withSize: .x728y90) {
//            print("Result: \($0)")
//            XCTAssertEqual($0.value(), "", "String should be no_fill")
//            networkExpectation.fulfill()
//        }
//        
//        self.waitForExpectations(timeout: 5) { handler in
//            
//        }
//    }
//    
//    func testBanner300x250() {
//        let networkExpectation = self.expectation(description: "Test banner 300x250 OKW 1")
//        
//        AdServerTappxFramework.sharedInstance.settings = self.settings
//        
//        DataManager.tappxBanner(withSize: .x300y250) {
//            print("Result: \($0)")
//            XCTAssertEqual($0.value(), "", "String should be no_fill")
//            networkExpectation.fulfill()
//        }
//        
//        self.waitForExpectations(timeout: 5) { handler in
//            
//        }
//    }
//    
//    func testInterstitialDefault() {
//        let networkExpectation = self.expectation(description: "Test interstitial Default OKW 1")
//        
//        AdServerTappxFramework.sharedInstance.settings = self.settings
//        
//        DataManager.tappxInterstitial() {
//            print("Result: \($0)")
//            XCTAssertEqual($0.value(), "", "String should be no_fill")
//            networkExpectation.fulfill()
//        }
//        
//        self.waitForExpectations(timeout: 5) { handler in
//            
//        }
//    }
//    
//    func testInterstitial320x480() {
//        let networkExpectation = self.expectation(description: "Test interstitial 320x480 OKW 1")
//        
//        AdServerTappxFramework.sharedInstance.settings = self.settings
//        
//        DataManager.tappxInterstitial(withSize: .x320y480) {
//            print("Result: \($0)")
//            XCTAssertEqual($0.value(), "", "String should be no_fill")
//            networkExpectation.fulfill()
//        }
//        
//        self.waitForExpectations(timeout: 5) { handler in
//            
//        }
//    }
//    
//    func testInterstitial480x320() {
//        let networkExpectation = self.expectation(description: "Test interstitial 480x320 OKW 1")
//        
//        AdServerTappxFramework.sharedInstance.settings = self.settings
//        
//        DataManager.tappxInterstitial(withSize: .x480y320) {
//            print("Result: \($0)")
//            XCTAssertEqual($0.value(), "", "String should be no_fill")
//            networkExpectation.fulfill()
//        }
//        
//        self.waitForExpectations(timeout: 5) { handler in
//            
//        }
//    }
//    
//    func testInterstitial768x1024() {
//        let networkExpectation = self.expectation(description: "Test interstitial 768x1024 OKW 1")
//        
//        AdServerTappxFramework.sharedInstance.settings = self.settings
//        
//        DataManager.tappxInterstitial(withSize: .x768y1024) {
//            print("Result: \($0)")
//            XCTAssertEqual($0.value(), "", "String should be no_fill")
//            networkExpectation.fulfill()
//        }
//        
//        self.waitForExpectations(timeout: 5) { handler in
//            
//        }
//    }
//    
//    func testInterstitial1024x768() {
//        let networkExpectation = self.expectation(description: "Test interstitial 1024x768 OKW 1")
//        
//        AdServerTappxFramework.sharedInstance.settings = self.settings
//        
//        DataManager.tappxInterstitial(withSize: .x1024y768) {
//            print("Result: \($0)")
//            XCTAssertEqual($0.value(), "", "String should be no_fill")
//            networkExpectation.fulfill()
//        }
//        
//        self.waitForExpectations(timeout: 5) { handler in
//            
//        }
//    }
    
    
    
}
