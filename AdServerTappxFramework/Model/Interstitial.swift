//
//  Interstitial.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 14/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

final class Interstitial: NSObject, TappxAdvertisement {
    
    var html: String
    
    init(with html: String) {
        self.html = html
        super.init()
    }
    
}
