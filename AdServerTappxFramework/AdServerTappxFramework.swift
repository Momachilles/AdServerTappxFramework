//
//  AdServerTappxFramework.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 21/10/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

struct TappxFrameworkConstants {
    static let clientIdKey = "ClientIdKey"
    static var tappxAssociationKey: UInt8 = 0
    static var tappxSettingsAssociationKey = "TappxSettings"
}


// MARK: - Adapter Protocols
public protocol TappxAdabtable {
    var adapterId: String { get set }
    func doSomething()
}

public extension TappxAdabtable {
    public func doSomething() {
        print("Let's do something")
    }
}

private protocol TappxAdaptableContainer {
    var adapters: [TappxAdabtable] { get set }
    func assignAdapters(new adapters: [TappxAdabtable])
    func addAdapter(adapter: TappxAdabtable)
    func removeAdapter(adapter: TappxAdabtable) throws
}

public class AdServerTappxFramework: NSObject {
    public static let sharedInstance = AdServerTappxFramework()
    ///This prevents others from using the default '()' initializer for this class.
    private override init() {}

    public static func sharedInstance(from clientId: String) {
        let framework = AdServerTappxFramework.sharedInstance
        framework.clientId = clientId
    }
    
}

// MARK: - Settings Protocol

enum Gender: String {
    case Male   = "male"
    case Female = "female"
    case Other  = "Other"
}

enum Marital: String {
    case Single         = "Single"
    case LivingCommon   = "Living Common"
    case Married        = "Married"
    case Divorced       = "Divorced"
    case Widowed        = "Widowed"
}

enum BannerForcedSize: String {
    case x320y50    = "320x50"
    case x728y90    = "728x90"
    case x300y250   = "300x250"
}

enum InterstitialForcedSize: String {
    case x320y480   = "320x480"
    case x480y320   = "480x320"
    case x768y1024  = "768x1024"
    case x1024y768  = "1024x768"
}

struct Settings {
    var sdkType: String?
    var mediator: String?
    var keywords: [String]?
    var yearOfBirth: String?
    var age: String?
    var gender: Gender?
    var marital: Marital?
}

protocol TappxSettings {
    var settings: Settings? { get set }
}

// MARK: - Client
extension AdServerTappxFramework {
    
    private var db: UserDefaults {
        return UserDefaults.standard
    }
    
    fileprivate var clientId: String? {
        get { return self.loadClientId() }
        set { if let value = newValue { self.saveClientId(value: value) }}
    }
    
    private func saveClientId(value: String) {
        self.db.set(value, forKey: TappxFrameworkConstants.clientIdKey)
        self.db.synchronize()
    }
    
    private func loadClientId() -> String? {
        return self.db.string(forKey: TappxFrameworkConstants.clientIdKey)
    }
    
}

// MARK: - Adapters
extension AdServerTappxFramework: TappxAdaptableContainer {
    
    internal func removeAdapter(adapter: TappxAdabtable) throws {
        guard let index = self.adapters.index(where: { $0.adapterId == adapter.adapterId }) else { throw NSError(domain: "Adapter doesn't exists", code: -10, userInfo: [:]) }
        self.adapters.remove(at: index)
    }

    internal func addAdapter(adapter: TappxAdabtable) {
        self.adapters.append(adapter)
    }

    internal func assignAdapters(new adapters: [TappxAdabtable]) {
        self.adapters = adapters
    }

    
    var adapters: [TappxAdabtable] {
        get { return objc_getAssociatedObject(self, &TappxFrameworkConstants.tappxAssociationKey) as! [TappxAdabtable] }
        set { objc_setAssociatedObject(self, &TappxFrameworkConstants.tappxAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
}

extension AdServerTappxFramework: TappxSettings  {
    
    var settings: Settings? {
        get { return (objc_getAssociatedObject(self, &TappxFrameworkConstants.tappxSettingsAssociationKey) as? Associated<Settings>)?.associatedValue() }
        set { objc_setAssociatedObject(self, &TappxFrameworkConstants.tappxSettingsAssociationKey, newValue.map { Associated<Settings>($0) }, .OBJC_ASSOCIATION_RETAIN) }
    }
}


