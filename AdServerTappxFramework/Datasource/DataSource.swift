//
//  DataSource.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 14/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

class DataSource: NSObject {
    
    dynamic private(set) var banner: Banner? {
        didSet {
            self.lastUpdated = Date()
        }
    }
    
    dynamic private(set) var interstitial: Interstitial? {
        didSet {
            self.lastUpdated = Date()
        }
    }
    
    dynamic private(set) var isUpdating: Bool = false
    dynamic private(set) var error: NSError? = .none

    private let signaler = TappxSignaler()
    private (set) var lastUpdated: Date
    
    override init() {
        self.lastUpdated = Date()
        super.init()
    }
    
    func tappxBanner(withSize forcedSize: BannerForcedSize? = .none) {
        
        let newBanner: (Banner) -> () = { [unowned self] banner in
            
            DispatchQueue.main.async { [unowned self] in
                self.banner = banner
            }
            
        }
        
        let raiseError: (Error) -> () = { error in
            
            DispatchQueue.main.async { [unowned self] in
                self.isUpdating = false
                let info = [NSLocalizedDescriptionKey: "\(error)"]
                let error = NSError(domain: "com.tappx.TappxFramework", code: -101, userInfo: info)
                self.error = error
            }
        }
        
        let future = self.signaler.future()
        
        future.start { result in
            
            switch result {
            case .success(let banner):
                newBanner(banner)
            case .failure(let error):
                raiseError(error)
            }
            
        }
        
    }
    
}
