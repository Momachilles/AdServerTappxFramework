//
//  DataManager.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 24/10/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import UIKit

internal class DataManager: NSObject {
    
    internal static func testNetwork(callback: @escaping () -> ()) {
        
        var params = TappxQueryStringParameters()
        
        params.fsz = "300x250"
        params.at = .intersticial
        params.test = 1
        
        let json = TappxBodyParameters()
        
        NetworkManager.sharedInstance.interstittial(tappxQueryStringParameters: params, tappxBodyParameters: json) { result in
            
            callback()
        }
        
        
    }
    
    internal static func tappxBanner() {
        
    }
    
    
}
