//
//  MenuScene.swift
//  box
//
//  Created by Colton Lipchak on 5/15/19.
//  Copyright © 2019 clipchak. All rights reserved.
//

import SpriteKit
import AudioToolbox
import GameKit

class MenuScene: SKScene, GKGameCenterControllerDelegate {
    
    var playBtn = SKSpriteNode()
    var highscoreLbl = SKLabelNode()
    var leaderboardBtn = SKSpriteNode()
    var infoBtn = SKSpriteNode()
    var unlocksBtn = SKSpriteNode()
    var soundBtn = SKSpriteNode()
    var soundHighlight = SKSpriteNode()
    var highlight = SKSpriteNode()
    
    //player and objects
    var player = SKSpriteNode()
    var warning = SKSpriteNode()
    var purpleBall = SKSpriteNode()
    
    var timeToWait = TimeInterval(2.50)
    var spawnNode = SKNode()
    var touchLocation = CGPoint()
    
    var moveAndRemoveDown = SKAction()
    var moveAndRemoveUp = SKAction()
    var moveAndRemoveLeft = SKAction()
    var moveAndRemoveRight = SKAction()
    
    override func didMove(to view: SKView) {
        setup()
        spawnPurpleBalls()
    }
    
    func setup(){
        let adChance = Int.random(in: 0 ..< 6)
        
        if(adChance == 3){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentInterstitialAd"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadInterstitialAd"), object: nil)
        }
        
        var ballString = "redBall"
        if UserDefaults.standard.object(forKey: "ballType") != nil {
            let ballType = UserDefaults.standard.string(forKey: "ballType")
            ballString = ballType!
        }
        
        //move purple ball down screen
        let downDistance = CGFloat(self.frame.height + 100)
        let movePurpleBallDown = SKAction.moveBy(x: 0 , y:-downDistance , duration: TimeInterval(0.0004 * downDistance))
        let removePurpleBallDown = SKAction.removeFromParent()
        moveAndRemoveDown = SKAction.sequence([movePurpleBallDown,removePurpleBallDown])
        
        //move purple ball up screen
        let upDistance = CGFloat(self.frame.height + 100)
        let movePurpleBallUp = SKAction.moveBy(x: 0 , y:upDistance , duration: TimeInterval(0.0004 * upDistance))
        let removePurpleBallUp = SKAction.removeFromParent()
        moveAndRemoveUp = SKAction.sequence([movePurpleBallUp,removePurpleBallUp])
        
        //move purple ball across from left side
        let leftDistance = CGFloat(self.frame.width + 100)
        let movePurpleBallLeft = SKAction.moveBy(x: leftDistance, y:0 , duration: TimeInterval(0.0004 * leftDistance))
        let removePurpleBallLeft = SKAction.removeFromParent()
        moveAndRemoveLeft = SKAction.sequence([movePurpleBallLeft,removePurpleBallLeft])
        
        //move purple ball across from right side
        let rightDistance = CGFloat(self.frame.width + 100)
        let movePurpleBallRight = SKAction.moveBy(x: -rightDistance, y:0 , duration: TimeInterval(0.0004 * rightDistance))
        let removePurpleBallRight = SKAction.removeFromParent()
        moveAndRemoveRight = SKAction.sequence([movePurpleBallRight,removePurpleBallRight])
        
        self.backgroundColor = UIColor.MyTheme.bgColor
        
        let boxLogo = SKLabelNode(text: "box")
        boxLogo.name = "boxLogo"
        boxLogo.fontName = "Helvetica Neue"
        boxLogo.fontSize = 78
        boxLogo.position = CGPoint(x: frame.width/2, y: frame.height-200)
        boxLogo.fontColor = .white
        addChild(boxLogo)
        
        player = SKSpriteNode(imageNamed: ballString)
        player.size = CGSize(width: 17, height: 17)
        player.position = CGPoint(x: boxLogo.position.x - 78, y: boxLogo.position.y + 5)
        addChild(player)
        
        highlight = SKSpriteNode(color: .black, size: CGSize(width: 80, height: 80))
        highlight.alpha = CGFloat(0.7)
        highlight.zPosition = 2
        highlight.isHidden = true
        addChild(highlight)
        
        playBtn = SKSpriteNode(color: .white, size: CGSize(width: 80, height: 80))
        playBtn.position = CGPoint(x: frame.width/2, y: frame.height/2)
        playBtn.name = "playBtn"
        playBtn.zPosition = 1
        addChild(playBtn)
        
        createHighscoreLabel()
        
        unlocksBtn = SKSpriteNode(imageNamed: "unlocks")
        unlocksBtn.size = CGSize(width: 60, height: 60)
        unlocksBtn.position = CGPoint(x: frame.width/5, y: frame.height/3)
        unlocksBtn.zPosition = 1
        unlocksBtn.name = "unlocksBtn"
        addChild(unlocksBtn)
        
        leaderboardBtn = SKSpriteNode(imageNamed: "leaderboard")
        leaderboardBtn.size = CGSize(width: 60, height: 60)
        leaderboardBtn.position = CGPoint(x: 2*frame.width/5, y: frame.height/3)
        leaderboardBtn.zPosition = 1
        leaderboardBtn.name = "leaderboardBtn"
        addChild(leaderboardBtn)
        
        infoBtn = SKSpriteNode(imageNamed: "info")
        infoBtn.size = CGSize(width: 60, height: 60)
        infoBtn.position = CGPoint(x: 3*frame.width/5, y: frame.height/3)
        infoBtn.zPosition = 1
        infoBtn.name = "infoBtn"
        addChild(infoBtn)
        
        soundBtn = SKSpriteNode(imageNamed: "soundBtn")
        soundBtn.size = CGSize(width: 60, height: 60)
        soundBtn.position = CGPoint(x: 4*frame.width/5, y: frame.height/3)
        soundBtn.zPosition = 1
        soundBtn.name = "soundBtn"
        addChild(soundBtn)
        
        soundHighlight = SKSpriteNode(color: UIColor.MyTheme.bgColor, size: soundBtn.size)
        soundHighlight.zPosition = 2
        soundHighlight.name = "soundBtn"
        soundHighlight.position = soundBtn.position
        soundHighlight.alpha = CGFloat(0.7)
        print("sound on: " + "\(soundOn)")
        
        if UserDefaults.standard.object(forKey: "soundOn") != nil {
            soundOn = UserDefaults.standard.bool(forKey: "soundOn")
        }
        
        if soundOn {
            soundHighlight.isHidden = true
        }
        
        addChild(soundHighlight)
        
        let playTxt = SKLabelNode(text: ">")
        playTxt.name = "playBtn"
        playTxt.verticalAlignmentMode = SKLabelVerticalAlignmentMode(rawValue: 1)!
        playTxt.fontName = "Helvetica Neue"
        playTxt.fontSize = 60
        playTxt.position = playBtn.position
        playTxt.fontColor = .black
        playTxt.zPosition = 2
        
        addChild(playTxt)
        
    }
    
    func createHighscoreLabel() {
        
        highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: playBtn.position.x, y: playBtn.position.y + 50)
        if let highestScore = UserDefaults.standard.object(forKey: "highscore"){
            highscoreLbl.text = "\(highestScore)"
        } else {
            highscoreLbl.text = "0"
        }
        highscoreLbl.zPosition = 2
        highscoreLbl.fontSize = 22
        highscoreLbl.fontColor = .white
        highscoreLbl.fontName = "Helvetica Neue Thin"
        
        addChild(highscoreLbl)
    }
    
    func spawnPurpleBalls(){
        warning.removeFromParent()
        var warningDelay = SKAction.wait(forDuration: timeToWait)
        var randomSpawn = Int(0)
        let warning = SKAction.run {
            randomSpawn = Int.random(in: 0 ..< 4)
            //print(randomSpawn)
            switch randomSpawn {
            case 0: self.warning = self.createWarningLeft()
            case 1: self.warning = self.createWarningRight()
            case 2: self.warning = self.createWarningTop()
            case 3: self.warning = self.createWarningBottom()
            default: break
            }
            self.addChild(self.warning)
        }
        
        let spawn = SKAction.run {
            //print(randomSpawn)
            switch randomSpawn {
            case 0: self.purpleBall = self.createPurpleBallsLeft()
            case 1: self.purpleBall = self.createPurpleBallsRight()
            case 2: self.purpleBall = self.createPurpleBallsTop()
            case 3: self.purpleBall = self.createPurpleBallsBottom()
            default: break
            }
            self.addChild(self.purpleBall)
            warningDelay = SKAction.wait(forDuration: self.timeToWait)
        }
        
        let removeWarning = SKAction.run {
            self.warning.removeFromParent()
        }
        
        //warn player, remove warning, fire purple ball, delay until next one
        let repeatSpawnDelay = SKAction.sequence([warning,warningDelay,removeWarning,spawn])
        let spawnDelayForever = SKAction.repeatForever(repeatSpawnDelay)
        spawnNode.run(spawnDelayForever)
        addChild(spawnNode)
    }
    
    func createWarningLeft() -> SKSpriteNode {
        warning = SKSpriteNode(imageNamed: "warning")
        warning.size = CGSize(width: 20, height: 20)
        let randomY = CGFloat.random(in: frame.minY + 10 ..<  frame.maxY - 10)
        warning.position = CGPoint(x: 10, y: randomY)
        return warning
    }
    
    func createWarningRight() -> SKSpriteNode {
        warning = SKSpriteNode(imageNamed: "warning")
        warning.size = CGSize(width: 20, height: 20)
        let randomY = CGFloat.random(in: frame.minY + 10 ..<  frame.maxY - 10)
        warning.position = CGPoint(x: frame.width-10, y: randomY)
        return warning
    }
    
    func createWarningTop() -> SKSpriteNode {
        warning = SKSpriteNode(imageNamed: "warning")
        warning.size = CGSize(width: 20, height: 20)
        let randomX = CGFloat.random(in: 10 ..<  frame.width - 10)
        warning.position = CGPoint(x: randomX, y: frame.maxY - 10)
        return warning
    }
    
    func createWarningBottom() -> SKSpriteNode {
        warning = SKSpriteNode(imageNamed: "warning")
        warning.size = CGSize(width: 20, height: 20)
        let randomX = CGFloat.random(in: 10 ..<  frame.width - 10)
        warning.position = CGPoint(x: randomX, y: frame.minY + 10)
        return warning
    }
    
    func createPurpleBallsLeft() -> SKSpriteNode{
        //spawn from left side
        purpleBall = SKSpriteNode(imageNamed: "purpleBall")
        purpleBall.position = CGPoint(x: warning.position.x - 10, y: warning.position.y)
        purpleBall.size = CGSize(width: 20, height: 20)
        purpleBall.physicsBody = SKPhysicsBody(circleOfRadius: purpleBall.frame.width/2)
        purpleBall.physicsBody?.affectedByGravity = false
        purpleBall.physicsBody?.isDynamic = false
        purpleBall.physicsBody?.categoryBitMask = CollisionBitMask.enemyCategory
        purpleBall.physicsBody?.collisionBitMask = 0
        purpleBall.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        purpleBall.run(moveAndRemoveLeft)
        return purpleBall
    }
    
    func createPurpleBallsRight() -> SKSpriteNode{
        //spawn from right side
        purpleBall = SKSpriteNode(imageNamed: "purpleBall")
        //set position to be warnings position but off the screen
        purpleBall.position = CGPoint(x: warning.position.x + 10, y: warning.position.y)
        
        purpleBall.size = CGSize(width: 20, height: 20)
        purpleBall.physicsBody = SKPhysicsBody(circleOfRadius: purpleBall.frame.width/2)
        purpleBall.physicsBody?.affectedByGravity = false
        purpleBall.physicsBody?.isDynamic = false
        purpleBall.physicsBody?.categoryBitMask = CollisionBitMask.enemyCategory
        purpleBall.physicsBody?.collisionBitMask = 0
        purpleBall.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        purpleBall.run(moveAndRemoveRight)
        return purpleBall
    }
    
    func createPurpleBallsTop() -> SKSpriteNode{
        //spawn from Top side
        purpleBall = SKSpriteNode(imageNamed: "purpleBall")
        //set position to be warnings position but off the screen
        purpleBall.position = CGPoint(x: warning.position.x, y: warning.position.y + 10)
        purpleBall.size = CGSize(width: 20, height: 20)
        purpleBall.physicsBody = SKPhysicsBody(circleOfRadius: purpleBall.frame.width/2)
        purpleBall.physicsBody?.affectedByGravity = false
        purpleBall.physicsBody?.isDynamic = false
        purpleBall.physicsBody?.categoryBitMask = CollisionBitMask.enemyCategory
        purpleBall.physicsBody?.collisionBitMask = 0
        purpleBall.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        purpleBall.run(moveAndRemoveDown)
        return purpleBall
    }
    func createPurpleBallsBottom() -> SKSpriteNode{
        //spawn from Top side
        purpleBall = SKSpriteNode(imageNamed: "purpleBall")
        //set position to be warnings position but off the screen
        purpleBall.position = CGPoint(x: warning.position.x, y: warning.position.y - 10)
        purpleBall.size = CGSize(width: 20, height: 20)
        purpleBall.physicsBody = SKPhysicsBody(circleOfRadius: purpleBall.frame.width/2)
        purpleBall.physicsBody?.affectedByGravity = false
        purpleBall.physicsBody?.isDynamic = false
        purpleBall.physicsBody?.categoryBitMask = CollisionBitMask.enemyCategory
        purpleBall.physicsBody?.collisionBitMask = 0
        purpleBall.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        purpleBall.run(moveAndRemoveUp)
        return purpleBall
    }
    
    @IBAction func showLeaderboard() {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        gKGCViewController.gameCenterDelegate = self
        viewControllerVar?.present(gKGCViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        touchLocation = (touch?.location(in: self))!
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "playBtn"{
                
            }
            if nodesArray.first?.name == "boxLogo"{
                if spawnNode.speed < 3000 {
                    if soundOn{
                       AudioServicesPlaySystemSound(1519)
                    }
                    spawnNode.speed = spawnNode.speed * 5
                    //print(spawnNode.speed)
                }
            }
            if nodesArray.first?.name == "playBtn"{
                highlight.size = CGSize(width: 80, height: 80)
                highlight.position = playBtn.position
                highlight.isHidden = false
            }
            if nodesArray.first?.name == "leaderboardBtn"{
                highlight.size = CGSize(width: 60, height: 60)
                highlight.position = leaderboardBtn.position
                highlight.isHidden = false
            }
            if nodesArray.first?.name == "infoBtn"{
                highlight.size = CGSize(width: 60, height: 60)
                highlight.position = infoBtn.position
                highlight.isHidden = false
            }
            if nodesArray.first?.name == "unlocksBtn"{
                highlight.size = CGSize(width: 60, height: 60)
                highlight.position = unlocksBtn.position
                highlight.isHidden = false
            }
        }
            
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlight.isHidden = true
        let nodesArray2 = self.nodes(at: touchLocation)
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "playBtn" && nodesArray2.first?.name == "playBtn"{
                if soundOn{
                    AudioServicesPlaySystemSound(1519)
                }
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene)
            }
            if nodesArray.first?.name == "leaderboardBtn" && nodesArray2.first?.name == "leaderboardBtn"{
                if soundOn{
                    AudioServicesPlaySystemSound(1519)
                }
                showLeaderboard()
            }
            if nodesArray.first?.name == "infoBtn" && nodesArray2.first?.name == "infoBtn"{
                if soundOn{
                    AudioServicesPlaySystemSound(1519)
                }
                let infoScene = InfoScene(size: self.size)
                infoScene.scaleMode = .aspectFit
                self.view?.presentScene(infoScene)
            }
            if nodesArray.first?.name == "unlocksBtn" && nodesArray2.first?.name == "unlocksBtn"{
                if soundOn{
                    AudioServicesPlaySystemSound(1519)
                }
                let unlocksScene = UnlocksScene(size: self.size)
                unlocksScene.scaleMode = .aspectFit
                self.view?.presentScene(unlocksScene)
            }
            if nodesArray.first?.name == "soundBtn" && nodesArray2.first?.name == "soundBtn"{
                if soundOn {
                    soundHighlight.isHidden = false
                    soundOn = false
                    UserDefaults.standard.set(false, forKey: "soundOn")
                } else{
                    soundHighlight.isHidden = true
                    soundOn = true
                    UserDefaults.standard.set(true, forKey: "soundOn")
                }
                
            }
        }
    }
    
}
