//
//  DataManager.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 24/10/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import UIKit

internal class DataManager: NSObject {
    
    internal static func tappxBanner(withSize forcedSize: BannerForcedSize? = .none, callback: @escaping ResultCallback<String>) throws {
        
        let json = TappxBodyParameters()
        var params = TappxQueryStringParameters()
        forcedSize.map { params.fsz = $0.rawValue }
        params.at = .banner
        
        #if DEBUG
            params.test = 1
        #else
            params.test = 0
        #endif
        
        try NetworkManager.sharedInstance.banner(tappxQueryStringParameters: params, tappxBodyParameters: json) { result in
            DispatchQueue.main.async() {
                //callback(result)
            }
        }
        
    }
    
    internal static func tappxInterstitial(withSize forcedSize: InterstitialForcedSize? = .none, callback: @escaping ResultCallback<String>) throws {
        
        let json = TappxBodyParameters()
        var params = TappxQueryStringParameters()
        forcedSize.map { params.fsz = $0.rawValue }
        params.at = .interstitial
        
        #if DEBUG
            params.test = 1
        #else
            params.test = 0
        #endif
        
        try NetworkManager.sharedInstance.banner(tappxQueryStringParameters: params, tappxBodyParameters: json) { result in
            DispatchQueue.main.async() {
                //callback(result)
            }
        }
        
    }
    
}
