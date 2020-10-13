//
//  UnlocksScene.swift
//  box
//
//  Created by Colton Lipchak on 5/21/19.
//  Copyright © 2019 clipchak. All rights reserved.
//

import SpriteKit
import SwiftySKScrollView
import AudioToolbox

class UnlocksScene: SKScene {
    
    var highScore = Int(0)
    var jewelCount = Int(0)
    var gamesPlayed = Int(0)
    
    var ballString = "redBall"
    var scrollView: SwiftySKScrollView?
    var moveableNode = SKNode()
    var ballSize = CGSize(width: 25, height: 25)
    var highlightSize = CGSize(width: 90, height: 90)
    var ballPrice = Int(20)
    
    var scroll = SKNode()
    
    var jewelsLbl = SKLabelNode()
    
    var highlight = SKSpriteNode()
    var highlightP1 = SKSpriteNode()
    
    var page1ScrollView = SKSpriteNode()
    
    //unlockable characters
    //1st row
    var redBall = SKSpriteNode()
    var blueBall = SKSpriteNode()
    var pinkBall = SKSpriteNode()
    
    //2nd row
    var cyanBall = SKSpriteNode()
    var brownBall = SKSpriteNode()
    var greenBall = SKSpriteNode()
    
    //3rd row
    var greyBall = SKSpriteNode()
    var neonBall = SKSpriteNode()
    var orangeBall = SKSpriteNode()
    
    //4th row
    var redbrownBall = SKSpriteNode()
    var whiteBall = SKSpriteNode()
    var seafoamBall = SKSpriteNode()
    
    //5th row
    var tanBall = SKSpriteNode()
    var paleblueBall = SKSpriteNode()
    var salmonBall = SKSpriteNode()
    
    //6th row
    var palepinkBall = SKSpriteNode()
    var lightgreenBall = SKSpriteNode()
    var violetBall = SKSpriteNode()
    
    var adBtn = SKSpriteNode()
    
    var unlockedChars = ["redBall"]
    
    
    func rateApp() {
        //"itms-apps://itunes.apple.com/app/" + "appId"
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/1463860524/") else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func setup(){
        self.backgroundColor = UIColor.MyTheme.bgColor
        
        //set high score vars and jewel count
        if UserDefaults.standard.object(forKey: "highscore") != nil {
            highScore = UserDefaults.standard.integer(forKey: "highscore")
        }
        
        if UserDefaults.standard.object(forKey: "jewelCount") != nil {
            jewelCount = UserDefaults.standard.integer(forKey: "jewelCount")
        }
        
        if UserDefaults.standard.object(forKey: "gamesPlayed") != nil {
            gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")
        }
        //set up array of unlocked characters
        if UserDefaults.standard.array(forKey: "unlockedCharacters") != nil{
            unlockedChars = UserDefaults.standard.array(forKey: "unlockedCharacters") as! [String]
            //print(unlockedChars)
        }
        
        jewelsLbl = createJewelsLabel()
        self.addChild(jewelsLbl)
        
        //adds black box to cover scroll
        let blackBox = SKSpriteNode()
        blackBox.color = UIColor.MyTheme.bgColor
        blackBox.size = CGSize(width: frame.width, height: frame.height)
        blackBox.zPosition = 3
        blackBox.position = CGPoint(x: frame.width/2, y: frame.height+50)
        addChild(blackBox)
        
        //adds unlocks text
        let unlocksTxt = SKLabelNode()
        unlocksTxt.text = "UNLOCKS"
        unlocksTxt.fontName = "Helvetica Neue Thin"
        unlocksTxt.fontSize = 32
        unlocksTxt.fontColor = .white
        unlocksTxt.position = CGPoint(x: frame.width/2, y: frame.height - 100)
        unlocksTxt.zPosition = 4
        //addChild(unlocksTxt)
        
        let gamesPlayedTxt = SKLabelNode()
        gamesPlayedTxt.text = "Games Played: \(gamesPlayed)"
        gamesPlayedTxt.fontName = "Helvetica Neue Thin"
        gamesPlayedTxt.fontSize = 24
        gamesPlayedTxt.fontColor = .white
        gamesPlayedTxt.position = CGPoint(x: frame.width/2, y: frame.height/2 + 60)
        gamesPlayedTxt.zPosition = 4
        //addChild(gamesPlayedTxt)
        
        adBtn = SKSpriteNode(color: .orange, size: CGSize(width: 300, height: 90))
        adBtn.position = CGPoint(x: frame.width/2, y: frame.height/2 + 150)
        adBtn.zPosition = 4
        adBtn.name = "adBtn"
        let adBtnText = SKLabelNode(text: "WATCH A VIDEO")
        adBtnText.fontName = "Helvetica Neue"
        adBtnText.fontSize = 30
        adBtnText.fontColor = .black
        
        let adBtnText2 = SKLabelNode(text: "+5")
        adBtnText2.fontName = "Helvetica Neue"
        adBtnText2.fontSize = 30
        adBtnText2.fontColor = .black
        adBtnText2.position.y = CGFloat(adBtnText2.position.y - 30)
        adBtnText2.position.x = CGFloat(adBtnText2.position.x - 20)
        
        let jewelPic = SKSpriteNode(imageNamed: "jewel")
        jewelPic.size = CGSize(width: 10, height: 23)
        jewelPic.zPosition = 4
        jewelPic.position.y = CGFloat(jewelPic.position.y - 19)
        jewelPic.position.x = CGFloat(jewelPic.position.x + 10)
        adBtn.addChild(jewelPic)
        adBtn.addChild(adBtnText)
        adBtn.addChild(adBtnText2)
        addChild(adBtn)
        
        //adds back button
        let backBtn = SKLabelNode()
        backBtn.name = "backBtn"
        backBtn.text = "<"
        backBtn.fontName = "Helvetica Neue UltraLight"
        backBtn.fontSize = 48
        backBtn.fontColor = .white
        backBtn.position = CGPoint(x: safeAreaLeft + 40, y: frame.height - 100)
        backBtn.zPosition = 4
        addChild(backBtn)
        
        //        let backBtn2 = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
        //        backBtn2.name = "backBtn"
        //        backBtn2.position = backBtn.position
        //        backBtn.zPosition = 2
        //        addChild(backBtn2)
        
        //sets up the scroll view
        addChild(moveableNode)
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0 , y: frame.height/2-100, width: frame.width, height: 500), moveableNode: moveableNode, direction: .vertical)
        
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: scrollView!.frame.height * 2) // makes it 3 times the height
        view?.addSubview(scrollView!)
        
        //add sprites for each page in the scrollView to make positioning your actual stuff later on much easier
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        page1ScrollView = SKSpriteNode(color: UIColor.MyTheme.boxColor, size: CGSize(width: scrollView.frame.width, height: 750))
        page1ScrollView.anchorPoint = CGPoint(x: 0, y: 1)
        page1ScrollView.position = CGPoint(x: 0, y: frame.midY + 40)
        moveableNode.addChild(page1ScrollView)
        
        // add sprites page 1
        highlightP1 = SKSpriteNode(color: .cyan, size: highlightSize)
        highlightP1.position = CGPoint(x: 0.75*frame.width/4, y: -(page1ScrollView.frame.height/2))
        highlightP1.alpha = CGFloat(0.5)
        highlightP1.isHidden = true
        page1ScrollView.addChild(highlightP1)
        
        redBall = SKSpriteNode(imageNamed: "redBall")
        redBall.name = "redBall"
        redBall.size = ballSize
        redBall.position = CGPoint(x: 0.75*frame.width/4, y: -(page1ScrollView.frame.height/12))
        
        if !unlockedChars.contains("redBall"){
           
        }
        page1ScrollView.addChild(redBall)
        
        blueBall = SKSpriteNode(imageNamed: "blueBall")
        blueBall.name = "blueBall"
        blueBall.size = ballSize
        blueBall.position = CGPoint(x: 2*frame.width/4, y: redBall.position.y)
        
        let blueBallLock = SKSpriteNode(color: .lightGray, size: highlightSize)
        let blueLockText2 = SKLabelNode(text: "Tap to Rate App")
        blueLockText2.fontName = "Helvetica Neue"
        blueLockText2.fontSize = 12
        blueLockText2.fontColor = .black
        blueLockText2.zPosition = 1
        
        blueBallLock.zPosition = 1.5
        blueBallLock.size = highlightSize
        blueBallLock.name = "blueBall"
        if !unlockedChars.contains("blueBall"){
            blueBallLock.addChild(blueLockText2)
            blueBall.addChild(blueBallLock)
        }
        page1ScrollView.addChild(blueBall)
        
        pinkBall = SKSpriteNode(imageNamed: "pinkBall")
        pinkBall.name = "pinkBall"
        pinkBall.size = ballSize
        pinkBall.position = CGPoint(x: 3.25*frame.width/4, y: blueBall.position.y)
        
        let pinkBallLock = SKSpriteNode(imageNamed: "lock")
        pinkBallLock.zPosition = 1.5
        pinkBallLock.size = highlightSize
        pinkBallLock.name = "pinkBall"
        if !unlockedChars.contains("pinkBall"){
            pinkBall.addChild(pinkBallLock)
        }
        page1ScrollView.addChild(pinkBall)
        
        // sprites page 2
        cyanBall = SKSpriteNode(imageNamed: "cyanBall")
        cyanBall.name = "cyanBall"
        cyanBall.size = ballSize
        cyanBall.position = CGPoint(x: 0.75*frame.width/4, y: 3 * -(page1ScrollView.frame.height/12))
        
        let cyanBallLock = SKSpriteNode(imageNamed: "lock")
        cyanBallLock.zPosition = 1.5
        cyanBallLock.size = highlightSize
        cyanBallLock.name = "cyanBall"
        if !unlockedChars.contains("cyanBall"){
            cyanBall.addChild(cyanBallLock)
        }
        page1ScrollView.addChild(cyanBall)
        
        brownBall = SKSpriteNode(imageNamed: "brownBall")
        brownBall.name = "brownBall"
        brownBall.size = ballSize
        brownBall.position = CGPoint(x: 2*frame.width/4, y: cyanBall.position.y)
        
        let brownBallLock = SKSpriteNode(imageNamed: "lock")
        brownBallLock.zPosition = 1.5
        brownBallLock.size = highlightSize
        brownBallLock.name = "brownBall"
        if !unlockedChars.contains("brownBall"){
            brownBall.addChild(brownBallLock)
        }
        page1ScrollView.addChild(brownBall)
        
        greenBall = SKSpriteNode(imageNamed: "greenBall")
        greenBall.name = "greenBall"
        greenBall.size = ballSize
        greenBall.position = CGPoint(x: 3.25*frame.width/4, y: brownBall.position.y)
        
        let greenBallLock = SKSpriteNode(imageNamed: "lock")
        greenBallLock.zPosition = 1.5
        greenBallLock.size = highlightSize
        greenBallLock.name = "greenBall"
        if !unlockedChars.contains("greenBall"){
            greenBall.addChild(greenBallLock)
        }
        page1ScrollView.addChild(greenBall)
        
        // sprites page 3
        greyBall = SKSpriteNode(imageNamed: "greyBall")
        greyBall.name = "greyBall"
        greyBall.size = ballSize
        greyBall.position = CGPoint(x: 0.75*frame.width/4, y: 5 * -(page1ScrollView.frame.height/12))
        let greyBallLock = SKSpriteNode(imageNamed: "lock")
        greyBallLock.zPosition = 1.5
        greyBallLock.size = highlightSize
        greyBallLock.name = "greyBall"
        if !unlockedChars.contains("greyBall"){
            greyBall.addChild(greyBallLock)
        }
        page1ScrollView.addChild(greyBall)
        
        neonBall = SKSpriteNode(imageNamed: "neonBall")
        neonBall.name = "neonBall"
        neonBall.size = ballSize
        neonBall.position = CGPoint(x: 2*frame.width/4, y: greyBall.position.y)
        let neonBallLock = SKSpriteNode(imageNamed: "lock")
        neonBallLock.zPosition = 1.5
        neonBallLock.size = highlightSize
        neonBallLock.name = "neonBall"
        if !unlockedChars.contains("neonBall"){
            neonBall.addChild(neonBallLock)
        }
        page1ScrollView.addChild(neonBall)
        
        orangeBall = SKSpriteNode(imageNamed: "orangeBall")
        orangeBall.name = "orangeBall"
        orangeBall.size = ballSize
        orangeBall.position = CGPoint(x: 3.25*frame.width/4, y: neonBall.position.y)
        let orangeBallLock = SKSpriteNode(imageNamed: "lock")
        orangeBallLock.zPosition = 1.5
        orangeBallLock.size = highlightSize
        orangeBallLock.name = "orangeBall"
        if !unlockedChars.contains("orangeBall"){
            orangeBall.addChild(orangeBallLock)
        }
        page1ScrollView.addChild(orangeBall)
        
        //sprites page 4
        redbrownBall = SKSpriteNode(imageNamed: "redbrownBall")
        redbrownBall.name = "redbrownBall"
        redbrownBall.size = ballSize
        redbrownBall.position = CGPoint(x: 0.75*frame.width/4, y: 7 * -(page1ScrollView.frame.height/12))
        let redbrownBallLock = SKSpriteNode(imageNamed: "lock")
        redbrownBallLock.zPosition = 1.5
        redbrownBallLock.size = highlightSize
        redbrownBallLock.name = "redbrownBall"
        if !unlockedChars.contains("redbrownBall"){
            redbrownBall.addChild(redbrownBallLock)
        }
        page1ScrollView.addChild(redbrownBall)
        
        
        whiteBall = SKSpriteNode(imageNamed: "whiteBall")
        whiteBall.name = "whiteBall"
        whiteBall.size = ballSize
        whiteBall.position = CGPoint(x: 2*frame.width/4, y: redbrownBall.position.y)
        let whiteBallLock = SKSpriteNode(imageNamed: "lock")
        whiteBallLock.zPosition = 1.5
        whiteBallLock.size = highlightSize
        whiteBallLock.name = "whiteBall"
        if !unlockedChars.contains("whiteBall"){
            whiteBall.addChild(whiteBallLock)
        }
        page1ScrollView.addChild(whiteBall)
        
        seafoamBall = SKSpriteNode(imageNamed: "seafoamBall")
        seafoamBall.name = "seafoamBall"
        seafoamBall.size = ballSize
        seafoamBall.position = CGPoint(x: 3.25*frame.width/4, y: whiteBall.position.y)
        let seafoamBallLock = SKSpriteNode(imageNamed: "lock")
        seafoamBallLock.zPosition = 1.5
        seafoamBallLock.size = highlightSize
        seafoamBallLock.name = "seafoamBall"
        if !unlockedChars.contains("seafoamBall"){
            seafoamBall.addChild(seafoamBallLock)
        }
        page1ScrollView.addChild(seafoamBall)
        
        //sprites page 5
        tanBall = SKSpriteNode(imageNamed: "tanBall")
        tanBall.name = "tanBall"
        tanBall.size = ballSize
        tanBall.position = CGPoint(x: 0.75*frame.width/4, y: 9 * -(page1ScrollView.frame.height/12))
        let tanBallLock = SKSpriteNode(imageNamed: "lock")
        tanBallLock.zPosition = 1.5
        tanBallLock.size = highlightSize
        tanBallLock.name = "tanBall"
        if !unlockedChars.contains("tanBall"){
            tanBall.addChild(tanBallLock)
        }
        page1ScrollView.addChild(tanBall)
        
        paleblueBall = SKSpriteNode(imageNamed: "paleblueBall")
        paleblueBall.name = "paleblueBall"
        paleblueBall.size = ballSize
        paleblueBall.position = CGPoint(x: 2*frame.width/4, y: tanBall.position.y)
        let paleblueBallLock = SKSpriteNode(imageNamed: "lock")
        paleblueBallLock.zPosition = 1.5
        paleblueBallLock.size = highlightSize
        paleblueBallLock.name = "paleblueBall"
        if !unlockedChars.contains("paleblueBall"){
            paleblueBall.addChild(paleblueBallLock)
        }
        page1ScrollView.addChild(paleblueBall)
        
        salmonBall = SKSpriteNode(imageNamed: "salmonBall")
        salmonBall.name = "salmonBall"
        salmonBall.size = ballSize
        salmonBall.position = CGPoint(x: 3.25*frame.width/4, y: paleblueBall.position.y)
        let salmonBallLock = SKSpriteNode(imageNamed: "lock")
        salmonBallLock.zPosition = 1.5
        salmonBallLock.size = highlightSize
        salmonBallLock.name = "salmonBall"
        if !unlockedChars.contains("salmonBall"){
            salmonBall.addChild(salmonBallLock)
        }
        page1ScrollView.addChild(salmonBall)
        
        
        //sprites page 6
        palepinkBall = SKSpriteNode(imageNamed: "palepinkBall")
        palepinkBall.name = "palepinkBall"
        palepinkBall.size = ballSize
        palepinkBall.position = CGPoint(x: 0.75*frame.width/4, y: 11 * -(page1ScrollView.frame.height/12))
        let palepinkBallLock = SKSpriteNode(imageNamed: "lock")
        palepinkBallLock.zPosition = 1.5
        palepinkBallLock.size = highlightSize
        palepinkBallLock.name = "palepinkBall"
        if !unlockedChars.contains("palepinkBall"){
            palepinkBall.addChild(palepinkBallLock)
        }
        page1ScrollView.addChild(palepinkBall)
        
        lightgreenBall = SKSpriteNode(imageNamed: "lightgreenBall")
        lightgreenBall.name = "lightgreenBall"
        lightgreenBall.size = ballSize
        lightgreenBall.position = CGPoint(x: 2*frame.width/4, y: palepinkBall.position.y)
        let lightgreenBallLock = SKSpriteNode(imageNamed: "lock")
        lightgreenBallLock.zPosition = 1.5
        lightgreenBallLock.size = highlightSize
        lightgreenBallLock.name = "lightgreenBall"
        if !unlockedChars.contains("lightgreenBall"){
            lightgreenBall.addChild(lightgreenBallLock)
        }
        page1ScrollView.addChild(lightgreenBall)
        
        
        violetBall = SKSpriteNode(imageNamed: "violetBall")
        violetBall.name = "violetBall"
        violetBall.size = ballSize
        violetBall.position = CGPoint(x: 3.25*frame.width/4, y: lightgreenBall.position.y)
        let violetBallLock = SKSpriteNode(imageNamed: "lock")
        violetBallLock.zPosition = 1.5
        violetBallLock.size = highlightSize
        violetBallLock.name = "violetBall"
        if !unlockedChars.contains("violetBall"){
            violetBall.addChild(violetBallLock)
        }
        page1ScrollView.addChild(violetBall)
        
    }
    
    override func didMove(to view: SKView) {
        setup()
        
        //puts ball type into a string
        if UserDefaults.standard.object(forKey: "ballType") != nil {
            let ballType = UserDefaults.standard.string(forKey: "ballType")
            ballString = ballType!
        }
        
        //shifts highlight to ball type
        if let findBall = page1ScrollView.childNode(withName: ballString) as? SKSpriteNode{
            highlightP1.position = findBall.position
            //highlightP1.color = UIColor.lightGray
            highlightP1.isHidden = false
        }
        
    }
    
    override func willMove(from view: SKView) {
        scrollView?.removeFromSuperview()
        scrollView = nil // nil out reference to deallocate properly
    }
    
    func createJewelsLabel() -> SKLabelNode{
        
        let jewelsLbl = SKLabelNode()
        jewelsLbl.position = CGPoint(x: self.frame.width - 40, y: self.frame.height - 25 - safeAreaTop)
        jewelsLbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode(rawValue: 1)!
        jewelsLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode(rawValue: 2)!
        
        let jewel = SKSpriteNode(imageNamed: "jewel")
        jewel.position = CGPoint(x: jewelsLbl.position.x+20, y: jewelsLbl.position.y)
        jewel.size = CGSize(width: 10, height: 23)
        jewel.zPosition = 5
        self.addChild(jewel)
        
        if UserDefaults.standard.object(forKey: "jewelCount") != nil {
            let jewelCount = UserDefaults.standard.integer(forKey: "jewelCount")
            jewelsLbl.text = "\(jewelCount)"
        } else {
            jewelsLbl.text = "0"
        }
        
        jewelsLbl.zPosition = 5
        jewelsLbl.fontSize = 26
        jewelsLbl.fontColor = UIColor.white
        jewelsLbl.fontName = "Helvetica Neue Thin"
        
//        jewelCount = 20000
//        jewelsLbl.text = "\(jewelCount)"
        return jewelsLbl
    }
    
    func ballDecision(ball: SKSpriteNode, ballString: String){
        if unlockedChars.contains(ballString){
            //highlightP1.color = .yellow
            highlightP1.position = ball.position
            UserDefaults.standard.set(ballString, forKey: "ballType")
        } else if jewelCount >= 20 {
            jewelCount -= 20
            jewelsLbl.text = "\(jewelCount)"
            UserDefaults.standard.set(jewelCount, forKey: "jewelCount")
            unlockedChars.append(ballString)
            UserDefaults.standard.set(unlockedChars, forKey: "unlockedCharacters")
            ball.removeAllChildren()
            //highlightP1.color = .yellow
            highlightP1.position = ball.position
            UserDefaults.standard.set(ballString, forKey: "ballType")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
            if nodesArray.first?.name == "adBtn"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playVideoAd"), object: nil)
            }
            
            if nodesArray.first?.name == "redBall"{
                //highlightP1.color = .lightGray
                highlightP1.position = redBall.position
                UserDefaults.standard.set("redBall", forKey: "ballType")
            }
            
            if nodesArray.first?.name == "blueBall"{
                if unlockedChars.contains("blueBall"){
                    //highlightP1.color = .lightGray
                    highlightP1.position = blueBall.position
                    UserDefaults.standard.set("blueBall", forKey: "ballType")
                } else {
                    rateApp()
                    unlockedChars.append("blueBall")
                    UserDefaults.standard.set(unlockedChars, forKey: "unlockedCharacters")
                    blueBall.removeAllChildren()
                    //highlightP1.color = .lightGray
                    highlightP1.position = blueBall.position
                    UserDefaults.standard.set("blueBall", forKey: "ballType")
                }
            }
            
            if nodesArray.first?.name == "pinkBall"{
                ballDecision(ball: pinkBall, ballString: "pinkBall")
            }
            
            if nodesArray.first?.name == "cyanBall"{
                ballDecision(ball: cyanBall, ballString: "cyanBall")
            }
            
            if nodesArray.first?.name == "brownBall"{
                ballDecision(ball: brownBall, ballString: "brownBall")
            }
            
            if nodesArray.first?.name == "greenBall"{
                ballDecision(ball: greenBall, ballString: "greenBall")
            }
            
            if nodesArray.first?.name == "greyBall"{
                ballDecision(ball: greyBall, ballString: "greyBall")
            }
            
            if nodesArray.first?.name == "neonBall"{
                ballDecision(ball: neonBall, ballString: "neonBall")
            }
            
            if nodesArray.first?.name == "orangeBall"{
                ballDecision(ball: orangeBall, ballString: "orangeBall")
            }
            
            if nodesArray.first?.name == "redbrownBall"{
                ballDecision(ball: redbrownBall, ballString: "redbrownBall")
            }
            
            if nodesArray.first?.name == "whiteBall"{
                ballDecision(ball: whiteBall, ballString: "whiteBall")
            }
            
            if nodesArray.first?.name == "seafoamBall"{
                ballDecision(ball: seafoamBall, ballString: "seafoamBall")
            }
            
            if nodesArray.first?.name == "tanBall"{
                ballDecision(ball: tanBall, ballString: "tanBall")
            }
            
            if nodesArray.first?.name == "paleblueBall"{
                ballDecision(ball: paleblueBall, ballString: "paleblueBall")
            }
            
            if nodesArray.first?.name == "salmonBall"{
                ballDecision(ball: salmonBall, ballString: "salmonBall")
            }
            
            if nodesArray.first?.name == "palepinkBall"{
                ballDecision(ball: palepinkBall, ballString: "palepinkBall")
            }
            
            if nodesArray.first?.name == "lightgreenBall"{
                ballDecision(ball: lightgreenBall, ballString: "lightgreenBall")
            }
            
            if nodesArray.first?.name == "violetBall"{
                ballDecision(ball: violetBall, ballString: "violetBall")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if UserDefaults.standard.object(forKey: "jewelCount") != nil {
            jewelCount = UserDefaults.standard.integer(forKey: "jewelCount")
        }
        jewelsLbl.text = "\(jewelCount)"
        UserDefaults.standard.set(jewelCount, forKey: "jewelCount")
    }
    
}
