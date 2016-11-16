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
    
    func testInitFramework() {
        
        AdServerTappxFramework.sharedInstance(from: "123")
        var s = Settings()
        s.age = "44"
        
        AdServerTappxFramework.sharedInstance.settings = s
        
        guard let age = AdServerTappxFramework.sharedInstance.settings?.age else {
            XCTFail("Not Age set")
            return
        }
        
        XCTAssertEqual("44", age, "Age is different")
        
        let body = TappxBodyParameters()
        
        do { let p = try body.json()
        } catch {
            
        }
        
    }

    
    func testClient() {
        let client = Greetings()
        client.sayHello()
        print("Adapter: \(client.adapterId)")
    }
    
    
    
}
