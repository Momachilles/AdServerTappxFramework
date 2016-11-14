//
//  DatasourceTests.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 14/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import XCTest

class DatasourceTests: XCTestCase {
    
    let context = UnsafeMutableRawPointer(bitPattern: 0)
    
    class TestableDataSource: DataSource {
        var initializedModelExpectation: XCTestExpectation?
        
//        init(expectation: XCTestExpectation?) {
//            expectation.map { self.initializedModelExpectation = $0 }
//            super.init()
//        }

    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    let dataSource = TestableDataSource()
    
    
    func testCanGetBanner() {
        
        let expected = expectation(description: "Banner default test")
        dataSource.initializedModelExpectation = expected
        dataSource.addObserver(self, forKeyPath: "banner", options: [.new], context: context)
        dataSource.addObserver(self, forKeyPath: "error", options: [.new], context: context)
        dataSource.tappxBanner()
        waitForExpectations(timeout: 15, handler: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == context {
            if keyPath == "banner" {
                self.dataSource.initializedModelExpectation?.fulfill()
            }
            
            if keyPath == "error" {
                XCTFail(self.dataSource.error?.localizedDescription ?? "Undefined error")
                self.dataSource.initializedModelExpectation?.fulfill()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    
}
