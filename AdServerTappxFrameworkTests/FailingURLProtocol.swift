//
//  FailingURLProtocol.swift
//  Passengr
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

class FailingURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client = self.client else { fatalError("Client is missing") }
        guard let url = request.url else { fatalError("URL is missing") }
        
        let error = NSError(domain: "com.tappx.TappxFramework", code: 404, userInfo: nil)
        guard let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil) else {
            fatalError("Response could not be created")
        }
        
        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client.urlProtocol(self, didFailWithError: error)
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // all data return at once, nothing to do
    }
}
