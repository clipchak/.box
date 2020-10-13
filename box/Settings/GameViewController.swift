//
//  GameViewController.swift
//  box
//
//  Created by Colton Lipchak on 5/15/19.
//  Copyright © 2019 clipchak. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit
import Firebase


class GameViewController: UIViewController, GKGameCenterControllerDelegate, GADRewardBasedVideoAdDelegate {
    var jewelCount = Int(0)
    var interstitial: GADInterstitial!
    
    //banner test ads: "ca-app-pub-3940256099942544/2934735716"
    //interstitial test ads: "ca-app-pub-3940256099942544/4411468910"
    //rewarded test ads: "ca-app-pub-3940256099942544/1712485313"
    
    //banner id: "ca-app-pub-7335163268569903/4204412356"
    //interstitial id: "ca-app-pub-7335163268569903/6019577976"
    //rewarded id: "ca-app-pub-7335163268569903/9767251290"
    
    var bannerID = "ca-app-pub-3940256099942544/2934735716"
    var interstitialID = "ca-app-pub-3940256099942544/4411468910"
    var rewardedID = "ca-app-pub-3940256099942544/1712485313"
    
    override func viewDidLayoutSubviews() {
    
        
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                safeAreaBottom = window.safeAreaInsets.bottom
                safeAreaLeft = window.safeAreaInsets.left
                safeAreaRight = window.safeAreaInsets.right
                safeAreaTop = window.safeAreaInsets.top
            }
        }
        
        //if UserDefaults.standard.object(forKey: "removeAdsPurchased") == nil{
        
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authPlayer()
        
        //init reward video ad
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: rewardedID)
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        initAdMobInterstitial()
        let BannerAd = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        BannerAd.frame = CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50)
        BannerAd.delegate = self as? GADBannerViewDelegate
        BannerAd.adUnitID = bannerID
        BannerAd.rootViewController = self
        BannerAd.backgroundColor = UIColor.MyTheme.bgColor
        BannerAd.tintColor = UIColor.MyTheme.bgColor
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "*************************"]
        
        BannerAd.load(request)
        view.addSubview(BannerAd)
        
        
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'GameScene.sks'
            let menuScene = MenuScene(size: self.view.frame.size)
            menuScene.scaleMode = .aspectFit
            view.presentScene(menuScene)
            
//            if let scene = SKScene(fileNamed: "MenuScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//                
//                // Present the scene
//                view.presentScene(scene)
//            }
            
            view.ignoresSiblingOrder = true
            //view.showsPhysics = true
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentInterstitialAd), name: NSNotification.Name(rawValue: "presentInterstitialAd"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.initAdMobInterstitial), name: NSNotification.Name(rawValue: "loadInterstitialAd"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playVideoAd), name: NSNotification.Name(rawValue: "playVideoAd"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callAlert), name: NSNotification.Name(rawValue: "callAlert"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callPlayAlert), name: NSNotification.Name(rawValue: "callPlayAlert"), object: nil)
        
    }
    
    @objc func initAdMobInterstitial(){
        interstitial = GADInterstitial(adUnitID: interstitialID)
        let request = GADRequest()
        interstitial.load(request)
    }
    
    @objc func presentInterstitialAd(){
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    @objc func playVideoAd() {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true{
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: rewardedID)
    }
    
    //reward user with jewels for watching video ad
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        if UserDefaults.standard.object(forKey: "jewelCount") != nil {
            jewelCount = UserDefaults.standard.integer(forKey: "jewelCount")
        }
        jewelCount += 5
        UserDefaults.standard.set(jewelCount, forKey: "jewelCount")
        
    }
    
    //alert the player about ad removal
    @objc func callAlert() {
        let alert = UIAlertController(title: "Ads Removed", message: "Ads are now removed. You may need to restart the app to see the changes take effect", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func callPlayAlert() {
        let alert = UIAlertController(title: "How to Play", message: "Tap to go up. Swipe to move from side to side. Collect the yellow balls and don't get hit by the purple balls. The yellow alerts show where the purple balls will come into the screen.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "GO!", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func authPlayer(){
        let localPLayer = GKLocalPlayer.local
        localPLayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                self.present(view!, animated: true, completion: nil)
                
            } else{
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
