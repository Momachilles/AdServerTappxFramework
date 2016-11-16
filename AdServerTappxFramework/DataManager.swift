//
//  DataManager.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 24/10/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import UIKit

internal class DataManager: NSObject {
    
    internal static func tappxBanner(withSize forcedSize: BannerForcedSize? = .none, callback: @escaping (Result<String>) -> ()) {
        
        var params = TappxQueryStringParameters()
        
        forcedSize.map { params.fsz = $0.rawValue }
        params.at = .banner
        
        #if DEBUG
            params.test = 1
        #else
            params.test = 0
        #endif
        
        let json = TappxBodyParameters()
        
        NetworkManager.sharedInstance.banner(tappxQueryStringParameters: params, tappxBodyParameters: json) {
            callback($0)
        }
        
    }
    
    internal static func tappxInterstitial(withSize forcedSize: InterstitialForcedSize? = .none, callback: @escaping (Result<String>) -> ()) {
        
        var params = TappxQueryStringParameters()
        
        forcedSize.map { params.fsz = $0.rawValue }
        params.at = .interstitial
        
        #if DEBUG
            params.test = 1
        #else
            params.test = 0
        #endif
        
        let json = TappxBodyParameters()
        
        NetworkManager.sharedInstance.interstitial(tappxQueryStringParameters: params, tappxBodyParameters: json) {
            callback($0)
        }
        
    }
    
    
}
