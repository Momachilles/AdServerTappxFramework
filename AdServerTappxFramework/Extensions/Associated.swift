//
//  Associated.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 06/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

internal final class Associated<T>: NSObject, NSCopying {
    public typealias `Type` = T
    public let value: Type
    
    public init(_ value: Type) { self.value = value }
    
    public func copy(with zone: NSZone?) -> Any {
        return type(of: self).init(value)
    }
}

internal extension Associated where T: NSCopying {
    internal func copy(with zone: NSZone) -> AnyObject {
        return type(of: self).init(value.copy(with: zone) as! Type)
    }
}
