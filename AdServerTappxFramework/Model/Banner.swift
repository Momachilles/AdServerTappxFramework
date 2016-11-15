//
//  Banner.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 14/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

protocol TappxAdvertisement {
    var html: String { get set }
    init(with html: String)
}


final class Banner: NSObject, TappxAdvertisement {
    
    var html: String
    
    init(with html: String) {
        self.html = html
        super.init()
    }
    
}

extension Banner {
    override public var debugDescription: String {
        let hex = "0x" + String(self.hashValue, radix: 16)
        return "Banner: (\(hex)) \"\(self.html)\""
    }
}

extension Banner {
    override public var description: String {
        let hex = "0x" + String(self.hashValue, radix: 16)
        return "Banner: (\(hex)) \"\(self.html)\""
    }
}


