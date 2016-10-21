//
//  Greetings.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 21/10/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

public class Greetings: NSObject, TappxAdabtable {
    public func sayHello() {
        print("Hello Rubén. Is it working?")
    }
    
    public var adapterId: String = "TestAdapter"
    
    public func initialize() {
        AdServerTappxFramework.sharedInstance(from: "123")
        AdServerTappxFramework.sharedInstance.assignAdapters(new: [self])
    }
}
