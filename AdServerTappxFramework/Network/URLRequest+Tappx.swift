//
//  URLRequest+Tappx.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 27/10/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import Foundation

protocol TappxRequest {
    var tappxQueryStringParameters: TappxQueryStringParameters? { get set }
    var tappxBodyParameters: TappxBodyParameters? { get set }
    var tappxHeaders: TappxHeaders? { get set }
}

struct RequestConstants {
    static var tappxQueryStringParametersAssociationKey = "TappxQueryStringParameters"
    static var tappxBodyParametersAssociationKey = "TappxBodyParameters"
    static var tappxHeadersAssociationKey = "TappxHeaders"
}

struct TappxQueryStringParameters {
    /// Timestamp in millisencods (epoch format)
    var ts: TimeInterval { return Date.timeIntervalBetween1970AndReferenceDate }
    /// Tappx APP Key
    var k: String = "pub-mon-android-yo"
    /// AdType: banner | interstitial
    var at: QueryAdType = .banner
    /// Forced Size (for banners): Used when SMART_BANNER is not configured, ex: 300x250
    var fsz: String?
    /// Request Test Ads: 0 by default, 1 for test
    var test = 0
    
    func urlString() -> String {
        
        var params: [String: String] = [
            "ts"    : "\(ts)",
            "k"     : k,
            "at"    : at.rawValue,
            "test"  :  "\(test)"
        ]
        
        if let fsz = fsz {
            params["fsz"] = fsz
        }
        
        return params.stringFromHttpParameters()
    }
    
}

struct TappxBodyParameters {
//    let params: [String: Any] = [
//        "okw": "1",
//        "sdkv": "3.0.0",
//        "sdkt": "native",
//        "gpscv": 9452030,
//        "gpslv": 8301430,
//        "mraid": 2.0,
//        "aid": "96bd03b6-defc-4203-83d3-dc1c730801f7",
//        "aida": "acc106e89b01a1ef12bd870089e0ed9d",
//        "dmn": "Samsung",
//        "dmo": "GT-i9300",
//        "dmp": "Galaxy S3",
//        "dos": "android",
//        "dov": "6.0.1",
//        "dsw": 1080,
//        "dsh": 1920,
//        "dsd": 3.0,
//        "dua": "Mozilla/5.0 (Linux; Android 5.0.1; en-us; SM-N910V Build/LRX22C) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.93 Mobile Safari/537.36",
//        "dln": "es-ES",
//        "dct": "wifi",
//        "soc": 21407,
//        "son": "Movistar",
//        "scc": "ES",
//        "noc": 21407,
//        "non": "Movistar",
//        "ncc": "ES",
//        "aln": "en-US",
//        "ab": "com.tappx.apptest",
//        "an": "AppTest for Tappx",
//        "gz": "+0000"
//    ]
    
    ///Optional KeyWords from developer/user. Requires a function to set this values (string comma separated per each key)
    ///Default: (empty)
    var okw: String {
        guard
            let settings = AdServerTappxFramework.sharedInstance.settings,
            let kws = settings.keywords
        else { return "" }
        return kws.joined(separator: ",")
    }
    
    //var okw = "1"
    
    ///SDK Version
    var sdkv = "3.0.0"
    
    ///SDK Type [Could be set by developer to create news SDK for other frameworks (PhoneGAP, Unity, etc.)]
    ///Default: Native
    var sdkt = "native"
    
    ///When we're called from any mediation system, in mediation SDK has be able to set their name, for example: admob, mopub, heyzap, fyber, etc.
    ///Default: (empty)
    var mediator = ""
    
    ///GooglePlayServices compiled version
    var gpscv = 9452030
    
    ///GooglePlayServices Lib Version (version installed in device)
    var gpslv = 8301430
    
    ///MRAID Supported Version
    var mraid = 2.0
    
    ///IDFA
    var aid = "96bd03b6-defc-4203-83d3-dc1c730801f7"
    
    ///AdvertisingID Alternative MD5
    var aida = "acc106e89b01a1ef12bd870089e0ed9d"
    
    ///Tracking Limited (0=No Limited, 1=Limited)
    var aidl = false
    
    ///Device Manufacturer Name
    var dmn = "Samsung"
    
    ///Device Model
    var dmo = "GT-i9300"
    
    ///Device Model ProductName
    var dmp = "Galaxy S3"
    
    ///Device Operating System
    var dos = "android"
    
    ///Device Operating System Version
    var dov = "6.0.1"
    
    ///Device Screen Width (take care device orientation)
    var dsw = 1080
    
    ///Device Screen Height (take care device orientation)
    var dsh = 1920
    
    ///Device Screen Density
    var dsd = 3.0
    
    ///Device User Agent
    var dua =  "Mozilla/5.0 (Linux; Android 5.0.1; en-us; SM-N910V Build/LRX22C) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.93 Mobile Safari/537.36"
    
    ///Device Configured Language
    var dln = "es-ES"
    
    ///Device Connection Type: 2G, 3G, UMTS, HDSPA, WIFI, etc...
    var dct = "wifi"
    
    ///SIM Operator Code (MCC + MNC)
    var soc = 21407
    
    ///SIM Operator Name
    var son = "Movistar"
    
    ///SIM Operator Country (ISO 3166-1 alpha-2)
    var scc = "ES"
    
    ///SIM Operator Code (MCC + MNC)
    var noc = 21407
    
    ///SIM Operator Name
    var non = "Movistar"
    
    ///Network Operator Country(ISO3166-1 alpha-2)
    var ncc = "ES"
    
    ///Application Language
    var aln = "en-US"
    
    ///Application Bundle/packagename
    var ab = "com.tappx.apptest"
    
    ///Application Name
    var an = "AppTest for Tappx"
    
    ///Geo coordinates (latitude, longitude) :: We need to add GEO data only if the APP has Permissions to get this info!
    var geo = ""
    
    ///Estimated accuracy of this location, in meters
    var ga = 0
    
    ///Milliseconds since location was updated.
    var gf = 0
    
    ///Time zone offset. e.g. Pacific Standard Time
    var gz = "+0000"
    
    ///Optional, Year Of Birth (4-digit integer)
    ///Default: (empty)
    var oyob = 0
    
    ///Optional, User Age
    var oage = 0
    
    
    ///Optional: Gender (M=male, F=female, O=Other)
    ///Default: (empty)
    var ogender = ""
    
    ///Optional, Marital (S=Single, L=LivingCommon, M=Married, D=Divorced, W=Widowed)
    ///Default: (empty)
    var omarital = ""
    
    private func parameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let label = child.label {
                parameters[label] = child.value
            }
        }
        
        //Mirror not working with stored properties
        parameters["okw"] = self.okw
        
        return parameters
    }
    
    func json() throws -> Data {
        let p = self.parameters()
        return try JSONSerialization.data(withJSONObject: p, options: JSONSerialization.WritingOptions.prettyPrinted)
    }
    
}

struct TappxHeaders {
    
    typealias TappxHeader = (header: String, value: String)
    
    ///Defines which kind of response has been received
    let xcontent: TappxHeader = ("x-content", "")
    
    ///Passed this time (seconds) new Banner will be requested (as if developer has called “loadAd()” but maintaining the AD until new AD has received. 
    ///If no AD has been received we will try again in x- refreshad seconds. (For interstitials this will only affects when TTL has been passed).
    let xrefreshad: TappxHeader = ("x-refreshad", "")
    
    ///Defines AD Time-To-Live (in seconds), passed this time, new request will be done as if developer has call “loadAd()”, The AD will be maintained until
    ///new AD has been received. If no AD has been received we will do a new request if x-refreshad has been set.
    let xttl: TappxHeader = ("x-ttl", "")

    ///Defines is AD can be scrolled inside of TappxView, used for show large Ads inside of an interstitial
    let xscrollable: TappxHeader = ("x-scrollable", "")
    
    ///AD Width: For center AD inside of View/Activity. For Mediator class, this will be the Size of the AD choose by the AdServer, maybe in other
    ///Mediation class we can receive other Size that will be override this one, if not we will use this one.
    let xwidth: TappxHeader = ("x-width", "")

    ///AD Height: Same than x-width but for Height
    let xheight: TappxHeader = ("x-height", "")
    
    ///Defines Force-Show-Time, close button only can be showed/clicked passed this time (in seconds)
    let xfst: TappxHeader = ("x-fst", "")
    
    ///(url). If this attribute has been defined, the url must to be called if an AD has been received. This url will return a 1x1 pixel, if something has failed 
    ///we will try until we receive HTTP 200.
    let xdeltrack: TappxHeader = ("x-deltrack", "")
    
    ///(url). If this attribute has been defined, the url must to be called if an AD has been showed. This url will return a 1x1 pixel, if something has failed 
    ///we will try until we receive HTTP 200.
    let ximptrack: TappxHeader = ("x-imptrack", "")
    
    ///(url). If this attribute has been defined, the url must to be called if an AD has been clicked. This url will return a 1x1 pixel, if something has failed 
    ///we will try until we receive HTTP 200.
    let xclktrack: TappxHeader = ("x-clktrack", "")
    
    ///Defines is Activity should be showed as Overlay if it is possible (has more space than the ad). F.ex: when 300x250 has been returned for 320x480).
    ///Default: 0
    let xoverlay: TappxHeader = ("x-overlay", "")

    ///Defines if the Ad has to be showed with any animation. By default without animation. Animation will be defined later.
    ///Default: none (or not defined)
    ///Other: random (sdk will choose one of existing animations randomly [except none])
    let xanimation: TappxHeader = ("x-animation", "")
    
}

extension URLRequest: TappxRequest {
    
    var tappxQueryStringParameters: TappxQueryStringParameters? {
        get { return (objc_getAssociatedObject(self, &RequestConstants.tappxQueryStringParametersAssociationKey) as? Associated<TappxQueryStringParameters>)?.associatedValue() }
        set { objc_setAssociatedObject(self, &RequestConstants.tappxQueryStringParametersAssociationKey, newValue.map { Associated<TappxQueryStringParameters>($0) }, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    var tappxBodyParameters: TappxBodyParameters? {
        get { return (objc_getAssociatedObject(self, &RequestConstants.tappxBodyParametersAssociationKey) as? Associated<TappxBodyParameters>)?.associatedValue() }
        set { objc_setAssociatedObject(self, &RequestConstants.tappxBodyParametersAssociationKey, newValue.map { Associated<TappxBodyParameters>($0) }, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    var tappxHeaders: TappxHeaders? {
        get { return (objc_getAssociatedObject(self, &RequestConstants.tappxHeadersAssociationKey) as? Associated<TappxHeaders>)?.associatedValue() }
        set { objc_setAssociatedObject(self, &RequestConstants.tappxHeadersAssociationKey, newValue.map { Associated<TappxHeaders>($0) }, .OBJC_ASSOCIATION_RETAIN) }
    }
}
