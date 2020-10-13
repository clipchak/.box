//
//  InfoScene.swift
//  box
//
//  Created by Colton Lipchak on 5/21/19.
//  Copyright © 2019 clipchak. All rights reserved.
//

import SpriteKit
import SwiftySKScrollView
import StoreKit
import AudioToolbox

class InfoScene: SKScene {
    
    var scrollView: SwiftySKScrollView?
    var moveableNode = SKNode()
    
    var page1ScrollView = SKSpriteNode()
    
    func setup(){
        self.backgroundColor = UIColor.MyTheme.bgColor
        
        let blackBox = SKSpriteNode()
        blackBox.color = UIColor.MyTheme.bgColor
        blackBox.size = CGSize(width: frame.width, height: frame.height)
        blackBox.zPosition = 1
        blackBox.position = CGPoint(x: frame.width/2, y: frame.height+150)
        addChild(blackBox)
        
        //adds back button
        let backBtn = SKLabelNode()
        backBtn.name = "backBtn"
        backBtn.text = "<"
        backBtn.fontName = "Helvetica Neue UltraLight"
        backBtn.fontSize = 48
        backBtn.fontColor = .white
        backBtn.position = CGPoint(x: 40, y: frame.height - 100)
        backBtn.zPosition = 2
        addChild(backBtn)
        
        //adds unlocks text
        let unlocksTxt = SKLabelNode()
        unlocksTxt.text = "CREDITS"
        unlocksTxt.fontName = "Helvetica Neue Thin"
        unlocksTxt.fontSize = 32
        unlocksTxt.fontColor = .white
        unlocksTxt.position = CGPoint(x: frame.width/2, y: frame.height - 100)
        unlocksTxt.zPosition = 2
        addChild(unlocksTxt)
        
//        let purchaseNode = SKSpriteNode(imageNamed: "restorePurchasesBtn")
//        purchaseNode.name = "restorePurchasesBtn"
//        purchaseNode.position = CGPoint(x: frame.width/2, y: frame.height - 160)
//        purchaseNode.zPosition = 2
//        purchaseNode.color = .white
//        purchaseNode.size = CGSize(width: 200, height: 80)
//        addChild(purchaseNode)
        
        //sets up the scroll view
        addChild(moveableNode)
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0 , y: frame.height/2-100, width: frame.width, height: 500), moveableNode: moveableNode, direction: .vertical)
        
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: scrollView!.frame.height * 2) // makes it 3 times the height
        view?.addSubview(scrollView!)
        
        //add sprites for each page in the scrollView to make positioning your actual stuff later on much easier
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        page1ScrollView = SKSpriteNode(color: UIColor.MyTheme.boxColor, size: CGSize(width: scrollView.frame.width, height: 750))
        page1ScrollView.anchorPoint = CGPoint(x: 0, y: 1)
        page1ScrollView.position = CGPoint(x: 0, y: frame.midY + 140)
        moveableNode.addChild(page1ScrollView)
        
        let clipTxt = SKLabelNode(text: "App Design and Programming")
        clipTxt.fontName = "Arial Bold"
        clipTxt.fontSize = 25
        //clipTxt.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode(rawValue: 1)!
        clipTxt.position = CGPoint(x: frame.width/2, y: -(page1ScrollView.frame.height/12))
        
        let clipTxt2 = SKLabelNode(text: "@clipchak, clipchak@gmail.com")
        clipTxt2.fontName = "Arial"
        clipTxt2.fontSize = 20
        clipTxt2.position = CGPoint(x: frame.width/2, y: -(page1ScrollView.frame.height/12) - 40)
        
        page1ScrollView.addChild(clipTxt)
        page1ScrollView.addChild(clipTxt2)
        
        let lippyTxt = SKLabelNode(text: "App Consultant")
        lippyTxt.fontName = "Arial Bold"
        lippyTxt.fontSize = 25
        lippyTxt.position = CGPoint(x: frame.width/2, y: -(page1ScrollView.frame.height/12) - 120)

        let lippyTxt2 = SKLabelNode(text: "@itslippy412")
        lippyTxt2.fontName = "Arial"
        lippyTxt2.fontSize = 20
        lippyTxt2.position = CGPoint(x: frame.width/2, y: -(page1ScrollView.frame.height/12) - 150)
        page1ScrollView.addChild(lippyTxt)
        page1ScrollView.addChild(lippyTxt2)
//
//        let crownTxt = SKLabelNode(text: "Crown icon: Rudityas W. Anggoro, ruwlabs.com")
//        crownTxt.fontName = "Arial"
//        crownTxt.fontSize = 15
//        crownTxt.position = CGPoint(x: frame.width/2, y: -(page1ScrollView.frame.height/12) - 250)
//        page1ScrollView.addChild(crownTxt)
//
//        let iconTxt = SKLabelNode(text: "Watermelon, pineapple, duck icons: Thiago Silva")
//        iconTxt.fontName = "Arial"
//        iconTxt.fontSize = 15
//        iconTxt.position = CGPoint(x: frame.width/2, y: -(page1ScrollView.frame.height/12) - 280)
//        page1ScrollView.addChild(iconTxt)
//
//        let iconTxt2 = SKLabelNode(text: "other nonball icons from: icons8.com")
//        iconTxt2.fontName = "Arial"
//        iconTxt2.fontSize = 15
//        iconTxt2.position = CGPoint(x: frame.width/2, y: -(page1ScrollView.frame.height/12) - 310)
//        page1ScrollView.addChild(iconTxt2)
//
//        let soundTxt = SKLabelNode(text: "Jewel collection sound: attributed to LloydEvans09")
//        soundTxt.fontName = "Arial"
//        soundTxt.fontSize = 15
//        soundTxt.position = CGPoint(x: frame.width/2, y: -(page1ScrollView.frame.height/12) - 340)
//        page1ScrollView.addChild(soundTxt)
//        let soundTxt2 = SKLabelNode(text: "freesound.org/s/187024/, no changes made to original sound")
//        soundTxt2.fontName = "Arial"
//        soundTxt2.fontSize = 15
//        soundTxt2.position = CGPoint(x: frame.width/2, y: -(page1ScrollView.frame.height/12) - 370)
//        page1ScrollView.addChild(soundTxt2)
        
    }
    
    override func didMove(to view: SKView) {
        setup()
    }
    override func willMove(from view: SKView) {
        scrollView?.removeFromSuperview()
        scrollView = nil // nil out reference to deallocate properly
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "backBtn"{
                if soundOn{
                    AudioServicesPlaySystemSound(1519)
                }
                let menuScene = MenuScene(size: self.size)
                menuScene.scaleMode = .aspectFit
                self.view?.presentScene(menuScene)
            }
            if nodesArray.first?.name == "restorePurchasesBtn"{
                //IAPService.shared.restorePurchases()
                
            }
        }
    }
}
