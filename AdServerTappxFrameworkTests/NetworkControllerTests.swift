//
//  NetworkControllerTests.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 14/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import XCTest

typealias Success = () -> ()
typealias Failure = () -> ()

class NetworkControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCanRequestSuccessfully() {
        
        let expected = expectation(description: "Request should be successful")
        
        let success: Success = {
            expected.fulfill()
        }
        
        let failure: Failure = {
            XCTFail("Request should not fail")
        }
        
        let configuration = URLSessionConfiguration.configurationWithProtocol(LocalURLProtocol.self)
        let networkController = NetworkController(with: configuration)
        guard let request = networkController.request(endpoint: .requestAd) else { fatalError("Request error") }
        networkController.execute(request: request, success: success, failure: failure)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testCanHandleBadStatusCode() {
        let expected = expectation(description: "Request should not be successful")
        
        let success: Success = {
            XCTFail("Request should fail")
        }
        
        let failure: Failure = {
            expected.fulfill()
        }
        
        let configuration = URLSessionConfiguration.configurationWithProtocol(BadStatusURLProtocol.self)
        let networkController = NetworkController(with: configuration)
        guard let request = networkController.request(endpoint: .requestAd) else { fatalError("Request error") }
        networkController.execute(request: request, success: success, failure: failure)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testCanHandleBadResponse() {
        let expected = expectation(description: "Request should not be successful")
        
        let success: Success = {
            XCTFail("Request should fail")
        }
        
        let failure: Failure = {
            expected.fulfill()
        }
        
        let configuration = URLSessionConfiguration.configurationWithProtocol(BadResponseURLProtocol.self)
        let networkController = NetworkController(with: configuration)
        guard let request = networkController.request(endpoint: .requestAd) else { fatalError("Request error") }
        networkController.execute(request: request, success: success, failure: failure)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testCanHandleBadURL() {
        let expected = expectation(description: "Request should not be successful")
        
        let success: Success = {
            XCTFail("Request should fail")
        }
        
        let failure: Failure = {
            expected.fulfill()
        }
        
        let configuration = URLSessionConfiguration.configurationWithProtocol(FailingURLProtocol.self)
        let networkController = NetworkController(with: configuration)
        guard let request = networkController.request(endpoint: .requestAd) else { fatalError("Request error") }
        networkController.execute(request: request, success: success, failure: failure)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
}

extension NetworkController {
    func execute(request: URLRequest, success: @escaping Success, failure: @escaping Failure) {
        self.data(for: request).start { result in
            switch result {
            case .success:
                success()
            case .failure:
                failure()
            }
        }
    }
}
