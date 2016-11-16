//
//  TappxViewController.swift
//  AdServerTappxFramework
//
//  Created by David Alarcon on 16/11/2016.
//  Copyright © 2016 4Crew. All rights reserved.
//

import UIKit


fileprivate protocol TappxViewControllerType  {
    var banner: Banner? { get set }
    var interstitial: Interstitial? { get set }
    var bannerView: UIView { get set }
    var interstitialView: UIView { get set }
    func reloadBanner()
    func reloadInterstitial()
}

public class TappxViewController: UIViewController, TappxViewControllerType {

    fileprivate lazy var interstitialView: UIView = UIView()
    fileprivate lazy var bannerView: UIView = UIView()

    fileprivate var interstitial: Interstitial? {
        didSet {
            self.reloadInterstitial()
        }
    }
    
    
    fileprivate var banner: Banner? {
        didSet {
            self.reloadBanner()
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadBanner() {

    }
    
    internal func reloadInterstitial() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
