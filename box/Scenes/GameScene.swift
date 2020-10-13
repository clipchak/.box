//
//  GameScene.swift
//  box
//
//  Created by Colton Lipchak on 5/15/19.
//  Copyright © 2019 clipchak. All rights reserved.
//

import SpriteKit
import UIKit
import AudioToolbox
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate {
    //sounds
    let scoreSound = SKAction.playSoundFileNamed("dripSound.wav", waitForCompletion: false)
    let loseSound = SKAction.playSoundFileNamed("loseSound.wav", waitForCompletion: true)
    let buzzSound = SKAction.playSoundFileNamed("buzzSound.mp3", waitForCompletion: false)
    let jewelSound = SKAction.playSoundFileNamed("coinSound.wav", waitForCompletion: false)
    
    //HUD stuff
    var hudBox = SKSpriteNode()
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var jewelsLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var topBox = SKSpriteNode()
    var bottomBox = SKSpriteNode()
    var groundBox = SKSpriteNode()
    
    var gameBox = SKSpriteNode()
    
    //player and objects
    var player = SKSpriteNode()
    //var warning = SKSpriteNode()
    var yellowBall = SKSpriteNode()
    var purpleBall = SKSpriteNode()
    var jewel = SKSpriteNode()
    
    var jewelsTotalCount = Int(0)
    var oldJewelsCount = Int(0)
    var jewelsThisGame = Int(0)
    
    var timeToWait = TimeInterval(2.50)
    var spawnNode = SKNode()
    var spawnNode2 = SKNode()
    var spawnNode3 = SKNode()
    var node2added = false
    var node3added = false
    
    //pause/restart vars
    var pauseBtn = SKSpriteNode()
    var replayBtn = SKSpriteNode()
    var restartBtn = SKSpriteNode()
    var gameEndBox = SKSpriteNode()
    var touchLocation = CGPoint()
    var unlocksBtn = SKSpriteNode()
    var leaderboardBtn = SKSpriteNode()
    var menuBtn = SKSpriteNode()
    
    var moveAndRemoveDown = SKAction()
    var moveAndRemoveUp = SKAction()
    var moveAndRemoveLeft = SKAction()
    var moveAndRemoveRight = SKAction()

    
    //game booleans
    var isDead = false
    var isGameStarted = false
    var pauseGlitch = false
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callPlayAlert"), object: nil)
        
        setup()
        spawnPlayer()
        startGame()
        
        spawnYellowBalls()
        
        spawnYellowBalls()
        
        spawnYellowBalls()
        
        spawnYellowBalls()
        
        spawnYellowBalls()
        
        spawnNode.run(spawnPurpleBalls())
        addChild(spawnNode)
        
        spawnJewels()
    }
    
    func setup(){
        
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
        
        //add score to the scene
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        //add highest score to the scene
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        jewelsLbl = createJewelsLabel()
        self.addChild(jewelsLbl)
        
        topBox = SKSpriteNode(color: UIColor.MyTheme.boxColor, size: CGSize(width: frame.width, height: 200 ))
        topBox.position = CGPoint(x: frame.width/2, y: frame.height - safeAreaTop)
        topBox.physicsBody = SKPhysicsBody(rectangleOf: topBox.size)
        topBox.physicsBody?.categoryBitMask = CollisionBitMask.boxCategory
        topBox.physicsBody?.collisionBitMask = 0
        topBox.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        topBox.physicsBody?.isDynamic = false
        topBox.physicsBody?.affectedByGravity = false
        topBox.zPosition = 2
        addChild(topBox)
        
        bottomBox = SKSpriteNode(color: UIColor.MyTheme.boxColor, size: CGSize(width: frame.width, height: 200 ))
        bottomBox.position = CGPoint(x: frame.width/2, y: 0 + safeAreaTop)
        bottomBox.physicsBody = SKPhysicsBody(rectangleOf: bottomBox.size)
        bottomBox.physicsBody?.categoryBitMask = CollisionBitMask.boxCategory
        bottomBox.physicsBody?.collisionBitMask = 0
        bottomBox.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        bottomBox.physicsBody?.isDynamic = false
        bottomBox.physicsBody?.affectedByGravity = false
        bottomBox.zPosition = 2
        addChild(bottomBox)
        
        //sets up the frame the user plays in
        gameBox = SKSpriteNode(color: UIColor.MyTheme.bgColor, size: CGSize(width: frame.width, height: topBox.frame.minY - bottomBox.frame.maxY))
        gameBox.position = CGPoint(x: frame.midX, y: frame.midY)
        gameBox.zPosition = 0
        addChild(gameBox)
    
        let adBox = SKSpriteNode(color: .black, size: CGSize(width: frame.width, height: 50))
        adBox.anchorPoint = CGPoint(x: 0.5, y: 0)
        adBox.position = CGPoint(x: frame.width/2, y: 0)
        addChild(adBox)
        
        //set contact around the frame of the screen
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.boxCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -7.3)
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = UIColor.MyTheme.bgColor
    }
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 50 - safeAreaTop)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "Helvetica Neue Bold"
        
        return scoreLbl
    }
    
    func createHighscoreLabel() -> SKLabelNode {
        hudBox.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        hudBox.color = UIColor.black
        hudBox.position = CGPoint(x: 0, y: self.frame.height - safeAreaTop - 60)
        hudBox.size = CGSize(width: self.frame.width, height: 1)
        hudBox.zPosition = 9
        self.addChild(hudBox)
        
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: 50, y: self.frame.height - safeAreaTop - 50)
        if let highestScore = UserDefaults.standard.object(forKey: "highscore"){
            highscoreLbl.text = "\(highestScore)"
        } else {
            highscoreLbl.text = "0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 22
        highscoreLbl.fontColor = UIColor.white
        highscoreLbl.fontName = "Helvetica Neue Thin"
        
        let bestLbl = SKLabelNode()
        bestLbl.zPosition = 5
        bestLbl.fontName = "Helvetica Neue Bold"
        bestLbl.fontColor = UIColor.white
        bestLbl.fontSize = 22
        bestLbl.text = "BEST"
        bestLbl.position = CGPoint(x: highscoreLbl.position.x, y: highscoreLbl.position.y + 20)
        
        self.addChild(bestLbl)
        return highscoreLbl
    }
    
    func createJewelsLabel() -> SKLabelNode{
        
        let jewelsLbl = SKLabelNode()
        jewelsLbl.position = CGPoint(x: self.frame.width - 30, y: self.frame.height - 25 - safeAreaTop)
        jewelsLbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode(rawValue: 1)!
        jewelsLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode(rawValue: 2)!
        
        let jewel = SKSpriteNode(imageNamed: "jewel")
        jewel.position = CGPoint(x: jewelsLbl.position.x+15, y: jewelsLbl.position.y)
        jewel.size = CGSize(width: 10, height: 23)
        jewel.zPosition = 5
        self.addChild(jewel)
        
        if UserDefaults.standard.object(forKey: "jewelCount") != nil {
            let jewelCount = UserDefaults.standard.integer(forKey: "jewelCount")
            oldJewelsCount = jewelCount
            jewelsLbl.text = "\(jewelCount)"
        } else {
            jewelsLbl.text = "0"
        }
        
        jewelsLbl.zPosition = 5
        jewelsLbl.fontSize = 26
        jewelsLbl.fontColor = UIColor.white
        jewelsLbl.fontName = "Helvetica Neue Thin"
        return jewelsLbl
    }
    
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:30, height:30)
        pauseBtn.position = CGPoint(x: gameBox.frame.minX + 20, y: gameBox.frame.minY - 25)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    
    func spawnPlayer(){
        var ballString = "redBall"
        if UserDefaults.standard.object(forKey: "ballType") != nil {
            let ballType = UserDefaults.standard.string(forKey: "ballType")
            ballString = ballType!
        }
        
        player = SKSpriteNode(imageNamed: ballString)
        player.size = CGSize(width: 25.0, height: 25.0)
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.categoryBitMask = CollisionBitMask.playerCategory
        player.physicsBody?.collisionBitMask = CollisionBitMask.groundCategory | CollisionBitMask.boxCategory
        player.physicsBody?.contactTestBitMask = CollisionBitMask.groundCategory |  CollisionBitMask.boxCategory | CollisionBitMask.scoreCategory | CollisionBitMask.enemyCategory
        
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        addChild(player)
    }
    
    func spawnYellowBalls(){
        var test = SKSpriteNode()
        var test2 = SKSpriteNode()
        var delayTime = Double.random(in: 0.5 ..< 3.0)
        let spawn1 = SKAction.run {
            test = self.createYellowBalls()
            delayTime = Double.random(in: 1.5 ..< 3.0)
            self.addChild(test)
        }
        
        let spawn2 = SKAction.run {
            test2 = self.createYellowBalls()
            delayTime = Double.random(in: 1.5 ..< 3.0)
            self.addChild(test2)
        }
        
        let remove1 = SKAction.run {
            test.removeFromParent()
        }
        
        let remove2 = SKAction.run {
            test2.removeFromParent()
        }
        
        let delay = SKAction.wait(forDuration: delayTime)
        let spawnDelay = SKAction.sequence([spawn1,delay,spawn2,delay,remove1,delay, remove2])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever)
        
    }
    
    func spawnPurpleBalls() -> SKAction{
        var warningTest = SKSpriteNode()
        var purpleBallTest = SKSpriteNode()
        var warningDelay = SKAction.wait(forDuration: timeToWait)
        var randomSpawn = Int(0)
        let warning = SKAction.run {
            randomSpawn = Int.random(in: 0 ..< 4)
            //print("1: " + "\(randomSpawn)")
            switch randomSpawn {
            case 0: warningTest = self.createWarningLeft()
            case 1: warningTest = self.createWarningRight()
            case 2: warningTest = self.createWarningTop()
            case 3: warningTest = self.createWarningBottom()
            default: break
            }
            self.addChild(warningTest)
        }
        
        let spawn = SKAction.run {
            //print("2: " + "\(randomSpawn)")
            //print("")
            switch randomSpawn {
            case 0: purpleBallTest = self.createPurpleBallsLeft(warning: warningTest)
            case 1: purpleBallTest = self.createPurpleBallsRight(warning: warningTest)
            case 2: purpleBallTest = self.createPurpleBallsTop(warning: warningTest)
            case 3: purpleBallTest = self.createPurpleBallsBottom(warning: warningTest)
            default: break
            }
            self.addChild(purpleBallTest)
            warningDelay = SKAction.wait(forDuration: self.timeToWait)
        }
        
        let removeWarning = SKAction.run {
            warningTest.removeFromParent()
        }
        
        //warn player, remove warning, fire purple ball, delay until next one
        let repeatSpawnDelay = SKAction.sequence([warning,warningDelay,removeWarning,spawn])
        let spawnDelayForever = SKAction.repeatForever(repeatSpawnDelay)
        
        //spawnNode2.run(spawnDelayForever)
        return spawnDelayForever
    }
    
    func spawnJewels(){
        let spawn = SKAction.run {
            self.jewel = self.createJewels()
            let chance = 10
            if(chance == 10){
                self.addChild(self.jewel)
            }
        }
        
        let remove = SKAction.run {
            self.jewel.removeFromParent()
        }
        
        let delay = SKAction.wait(forDuration: 5.0)
        let spawnDelay = SKAction.sequence([spawn,delay,remove])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever)
    }
    
    func createYellowBalls() -> SKSpriteNode{
        let yellowBall2 = SKSpriteNode(imageNamed: "yellowBall")
        
        let randomX = CGFloat.random(in: 10 ..< frame.width - 10)
        let randomY = CGFloat.random(in: gameBox.frame.minY + 10 ..< gameBox.frame.maxY - 10)
        yellowBall2.position = CGPoint(x: randomX, y: randomY)
        yellowBall2.size = CGSize(width: 20, height: 20)
        yellowBall2.physicsBody = SKPhysicsBody(circleOfRadius: yellowBall2.frame.width/2)
        yellowBall2.physicsBody?.affectedByGravity = false
        yellowBall2.physicsBody?.isDynamic = false
        yellowBall2.physicsBody?.categoryBitMask = CollisionBitMask.scoreCategory
        yellowBall2.physicsBody?.collisionBitMask = 0
        yellowBall2.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        return yellowBall2
    }
    
    func createJewels() -> SKSpriteNode{
        jewel = SKSpriteNode(imageNamed: "jewel")
        
        let randomX = CGFloat.random(in: 10 ..< frame.width - 10)
        let randomY = CGFloat.random(in: gameBox.frame.minY + 10 ..< gameBox.frame.maxY - 10)
        jewel.position = CGPoint(x: randomX, y: randomY)
        jewel.size = CGSize(width: 13, height: 29)
        jewel.physicsBody = SKPhysicsBody(circleOfRadius: jewel.frame.width/2)
        jewel.physicsBody?.affectedByGravity = false
        jewel.physicsBody?.isDynamic = false
        jewel.physicsBody?.categoryBitMask = CollisionBitMask.jewelCategory
        jewel.physicsBody?.collisionBitMask = 0
        jewel.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        return jewel
    }
    
    func createWarningLeft() -> SKSpriteNode {
        let warning1 = SKSpriteNode(imageNamed: "warning")
        warning1.size = CGSize(width: 20, height: 20)
        let randomY = CGFloat.random(in: gameBox.frame.minY + 10 ..<  gameBox.frame.maxY - 10)
        warning1.position = CGPoint(x: 10, y: randomY)
        return warning1
    }
    
    func createWarningRight() -> SKSpriteNode {
        let warning1 = SKSpriteNode(imageNamed: "warning")
        warning1.size = CGSize(width: 20, height: 20)
        let randomY = CGFloat.random(in: gameBox.frame.minY + 10 ..<  gameBox.frame.maxY - 10)
        warning1.position = CGPoint(x: frame.width-10, y: randomY)
        return warning1
    }
    
    func createWarningTop() -> SKSpriteNode {
        let warning1 = SKSpriteNode(imageNamed: "warning")
        warning1.size = CGSize(width: 20, height: 20)
        let randomX = CGFloat.random(in: 10 ..<  frame.width - 10)
        warning1.position = CGPoint(x: randomX, y: gameBox.frame.maxY - 10)
        return warning1
    }
    
    func createWarningBottom() -> SKSpriteNode {
        let warning1 = SKSpriteNode(imageNamed: "warning")
        warning1.size = CGSize(width: 20, height: 20)
        let randomX = CGFloat.random(in: 10 ..<  frame.width - 10)
        warning1.position = CGPoint(x: randomX, y: gameBox.frame.minY + 10)
        return warning1
    }
    
    func createPurpleBallsLeft(warning: SKSpriteNode) -> SKSpriteNode{
        //spawn from left side
        let purpleBall1 = SKSpriteNode(imageNamed: "purpleBall")
        purpleBall1.position = CGPoint(x: warning.position.x - 10, y: warning.position.y)
        purpleBall1.size = CGSize(width: 20, height: 20)
        purpleBall1.physicsBody = SKPhysicsBody(circleOfRadius: purpleBall1.frame.width/2)
        purpleBall1.physicsBody?.affectedByGravity = false
        purpleBall1.physicsBody?.isDynamic = false
        purpleBall1.physicsBody?.categoryBitMask = CollisionBitMask.enemyCategory
        purpleBall1.physicsBody?.collisionBitMask = 0
        purpleBall1.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        purpleBall1.run(moveAndRemoveLeft)
        return purpleBall1
    }
    
    func createPurpleBallsRight(warning: SKSpriteNode) -> SKSpriteNode{
        //spawn from right side
        let purpleBall1 = SKSpriteNode(imageNamed: "purpleBall")
        //set position to be warnings position but off the screen
        purpleBall1.position = CGPoint(x: warning.position.x + 10, y: warning.position.y)
        
        purpleBall1.size = CGSize(width: 20, height: 20)
        purpleBall1.physicsBody = SKPhysicsBody(circleOfRadius: purpleBall1.frame.width/2)
        purpleBall1.physicsBody?.affectedByGravity = false
        purpleBall1.physicsBody?.isDynamic = false
        purpleBall1.physicsBody?.categoryBitMask = CollisionBitMask.enemyCategory
        purpleBall1.physicsBody?.collisionBitMask = 0
        purpleBall1.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        purpleBall1.run(moveAndRemoveRight)
        return purpleBall1
    }
    
    func createPurpleBallsTop(warning: SKSpriteNode) -> SKSpriteNode{
        //spawn from Top side
        let purpleBall1 = SKSpriteNode(imageNamed: "purpleBall")
        //set position to be warnings position but off the screen
        purpleBall1.position = CGPoint(x: warning.position.x, y: warning.position.y + 10)
        purpleBall1.size = CGSize(width: 20, height: 20)
        purpleBall1.physicsBody = SKPhysicsBody(circleOfRadius: purpleBall1.frame.width/2)
        purpleBall1.physicsBody?.affectedByGravity = false
        purpleBall1.physicsBody?.isDynamic = false
        purpleBall1.physicsBody?.categoryBitMask = CollisionBitMask.enemyCategory
        purpleBall1.physicsBody?.collisionBitMask = 0
        purpleBall1.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        purpleBall1.run(moveAndRemoveDown)
        return purpleBall1
    }
    func createPurpleBallsBottom(warning: SKSpriteNode) -> SKSpriteNode{
        //spawn from Top side
        let purpleBall1 = SKSpriteNode(imageNamed: "purpleBall")
        //set position to be warnings position but off the screen
        purpleBall1.position = CGPoint(x: warning.position.x, y: warning.position.y - 10)
        purpleBall1.size = CGSize(width: 20, height: 20)
        purpleBall1.physicsBody = SKPhysicsBody(circleOfRadius: purpleBall1.frame.width/2)
        purpleBall1.physicsBody?.affectedByGravity = false
        purpleBall1.physicsBody?.isDynamic = false
        purpleBall1.physicsBody?.categoryBitMask = CollisionBitMask.enemyCategory
        purpleBall1.physicsBody?.collisionBitMask = 0
        purpleBall1.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        purpleBall1.run(moveAndRemoveUp)
        return purpleBall1
    }
    
    func flashScreen(){
        let wait1 = SKAction.wait(forDuration: 0.1)
        let flash = SKAction.run {
            self.gameBox.alpha = CGFloat(0.8)
            self.gameBox.color = .brown
        }
        let returnToColor = SKAction.run {
            self.gameBox.color = UIColor.MyTheme.bgColor
        }
        let flashSequence = SKAction.sequence([flash,wait1,returnToColor])
        self.run(flashSequence)
    }
    
    func startGame(){
        if isDead == false && isGameStarted == true{
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx:0, dy: 30))
        }
        if isGameStarted == false {
            isGameStarted = true
            player.physicsBody?.affectedByGravity = true
            createPauseBtn()
            player.isHidden = false
            //scoreLbl.isHidden = false
        }
    }
    
    func createRestartMenu(){
        gameEndBox = SKSpriteNode(color: UIColor.MyTheme.boxColor, size: CGSize(width: frame.width-75, height: gameBox.frame.height-30))
        gameEndBox.position = CGPoint(x: frame.midX, y: frame.midY)
        gameEndBox.zPosition = 3
        gameEndBox.setScale(0)
        self.addChild(gameEndBox)
        gameEndBox.run(SKAction.scale(to: 1.0, duration: 0.4))
        topBox.zPosition = 7
        
        let gameOverTxt = SKLabelNode(text: "GAME OVER")
        gameOverTxt.fontSize = 35
        gameOverTxt.fontName = "Helvetica Neue"
        gameOverTxt.fontColor = .white
        gameOverTxt.zPosition = 3
        gameOverTxt.position = CGPoint(x: frame.midX, y: gameBox.frame.height + 30)
        addChild(gameOverTxt)
        
        scoreLbl.zPosition = 3
        scoreLbl.position = CGPoint(x: frame.midX, y: gameBox.frame.height-30)
        
        replayBtn = SKSpriteNode(color: .red, size: CGSize(width: frame.midX, height: 50))
        replayBtn.zPosition = 3
        replayBtn.name = "replayBtn"
        replayBtn.position = CGPoint(x: scoreLbl.position.x, y: scoreLbl.position.y - 50)
        
        let replayTxt = SKLabelNode(text: "RESTART")
        replayTxt.fontSize = 25
        replayTxt.fontName = "Helvetica Neue"
        replayTxt.fontColor = .white
        replayTxt.zPosition = 3
        replayTxt.position = CGPoint(x: replayBtn.position.x, y: replayBtn.position.y - 10)
        addChild(replayTxt)
        addChild(replayBtn)
        
        unlocksBtn = SKSpriteNode(color: .orange, size: CGSize(width: frame.midX, height: 50))
        unlocksBtn.zPosition = 3
        unlocksBtn.name = "unlocksBtn"
        unlocksBtn.position = CGPoint(x: scoreLbl.position.x, y: scoreLbl.position.y - 110)
        let unlocksTxt = SKLabelNode(text: "UNLOCKS")
        unlocksTxt.fontSize = 25
        unlocksTxt.fontName = "Helvetica Neue"
        unlocksTxt.fontColor = .white
        unlocksTxt.zPosition = 3
        unlocksTxt.position = CGPoint(x: unlocksBtn.position.x, y: unlocksBtn.position.y - 10)
        addChild(unlocksTxt)
        addChild(unlocksBtn)
        
        leaderboardBtn = SKSpriteNode(color: .blue, size: CGSize(width: frame.midX, height: 50))
        leaderboardBtn.zPosition = 3
        leaderboardBtn.name = "leaderboardBtn"
        leaderboardBtn.position = CGPoint(x: scoreLbl.position.x, y: scoreLbl.position.y - 170)
        let leaderboardTxt = SKLabelNode(text: "LEADERBOARD")
        leaderboardTxt.fontSize = 23
        leaderboardTxt.fontName = "Helvetica Neue"
        leaderboardTxt.fontColor = .white
        leaderboardTxt.zPosition = 3
        leaderboardTxt.position = CGPoint(x: leaderboardBtn.position.x, y: leaderboardBtn.position.y - 10)
        addChild(leaderboardTxt)
        addChild(leaderboardBtn)
        
        menuBtn = SKSpriteNode(color: .purple, size: CGSize(width: frame.midX, height: 50))
        menuBtn.zPosition = 3
        menuBtn.name = "menuBtn"
        menuBtn.position = CGPoint(x: scoreLbl.position.x, y: scoreLbl.position.y - 230)
        let menuTxt = SKLabelNode(text: "MENU")
        menuTxt.fontSize = 25
        menuTxt.fontName = "Helvetica Neue"
        menuTxt.fontColor = .white
        menuTxt.zPosition = 3
        menuTxt.position = CGPoint(x: menuBtn.position.x, y: menuBtn.position.y - 10)
        addChild(menuTxt)
        addChild(menuBtn)
        
        player.isHidden = true
        
        let adChance = Int.random(in: 0 ..< 5)
        
        if(adChance == 1){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentInterstitialAd"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadInterstitialAd"), object: nil)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodesArray2 = self.nodes(at: touchLocation)
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "replayBtn" && nodesArray2.first?.name == "replayBtn"{
                if soundOn{
                    AudioServicesPlaySystemSound(1519)
                }
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene)
            }
            if nodesArray.first?.name == "unlocksBtn" && nodesArray2.first?.name == "unlocksBtn"{
                if soundOn{
                    AudioServicesPlaySystemSound(1519)
                }
                let unlocksScene = UnlocksScene(size: self.size)
                unlocksScene.scaleMode = .aspectFit
                self.view?.presentScene(unlocksScene)
            }
            if nodesArray.first?.name == "leaderboardBtn" && nodesArray2.first?.name == "leaderboardBtn"{
                if soundOn{
                    AudioServicesPlaySystemSound(1519)
                }
                showLeaderboard()
            }
            if nodesArray.first?.name == "menuBtn" && nodesArray2.first?.name == "menuBtn"{
                if soundOn{
                    AudioServicesPlaySystemSound(1519)
                }
                let menuScene = MenuScene(size: self.size)
                menuScene.scaleMode = .aspectFit
                self.view?.presentScene(menuScene)
            }
        }
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
    
    func storeHighScore(){
        //store the player's high score
        saveHighscore(gameScore: Int(scoreLbl.text!)!, boardId: "boxHighscore")
        if UserDefaults.standard.object(forKey: "highscore") == nil {
            UserDefaults.standard.set(Int(scoreLbl.text!)!, forKey: "highscore")
        }
        if UserDefaults.standard.object(forKey: "highscore") != nil {
            let hscore = UserDefaults.standard.integer(forKey: "highscore")
            if hscore < Int(scoreLbl.text!)!{
                UserDefaults.standard.set(scoreLbl.text, forKey: "highscore")
            }
        } else {
            UserDefaults.standard.set(0, forKey: "highscore")
        }
    }
    
    func storeJewels(){
        if UserDefaults.standard.object(forKey: "jewelCount") != nil {
            let jewelCount = UserDefaults.standard.integer(forKey: "jewelCount")
            let newCount = jewelCount + jewelsThisGame
            UserDefaults.standard.set(newCount, forKey: "jewelCount")
        } else {
            UserDefaults.standard.set(jewelsThisGame, forKey: "jewelCount")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isPaused == false && pauseGlitch{
            print("YEEEEEEEET")
            //print(pauseBtn.texture)
            pauseBtn.texture = SKTexture(imageNamed: "pause")
            pauseGlitch = false
        }
        let touch = touches.first
        touchLocation = (touch?.location(in: self))!
        //set the physics at beginning of the game
        if isDead == false && isGameStarted == true && self.isPaused == false{
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx:0, dy: 9.5))
        }
        for touch in touches{
            let location = touch.location(in: self)
            
            //if the player is dead and hits restart button, set high score and restart
            if isDead == true{
               
            } else {
                //add pause button
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                        pauseGlitch = true
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                        pauseGlitch = false
                    }
                }
            }
        }

    }
    
    func increaseDifficulty() {
        //inc speed of 1st node
        if score > 30 && spawnNode.speed < 1.25 {
            spawnNode.speed = spawnNode.speed * 1.015
            //print(spawnNode.speed)
        }
        
        //inc speed of 2nd node
        if spawnNode2.speed < 1.25 && score > 83  && node2added {
            spawnNode2.speed = spawnNode2.speed * 1.015
            //print("node 2 speed: " + "\(spawnNode2.speed)")
        }
        
        //inc speed of 3rd node
        if spawnNode3.speed < 1.25 && score > 113 && node3added {
            spawnNode3.speed = spawnNode3.speed * 1.015
            //print("node 3 speed: " + "\(spawnNode3.speed)")
        }
        
        //adding 2nd node
        if score >= 40 && node2added == false {
            let addNodeChance = Int.random(in: 0 ..< 5)
            if addNodeChance == 2 {
                spawnYellowBalls()
                node2added = true
                spawnNode2.run(spawnPurpleBalls())
                addChild(spawnNode2)
            }
        }
        
        //adding 3rd node
        if score >= 100 && node3added == false {
            let addNodeChance = Int.random(in: 0 ..< 5)
            if addNodeChance == 2 {
                spawnYellowBalls()
                node3added = true
                spawnNode3.run(spawnPurpleBalls())
                addChild(spawnNode3)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //allows the player to be moved along x-axis by finger movement across the screen
        if(self.isPaused == false && self.isDead == false){
            for touch in touches{
                let curLocation = touch.location(in: self)
                let prevLocation = touch.previousLocation(in: self)
                let difference = curLocation.x - prevLocation.x
                var newPosition = player.position.x + difference
                
                if difference < 0 {
                    newPosition  = newPosition - 1.5
                }
                if difference > 0 {
                    newPosition  = newPosition + 1.5
                }
                
                if(newPosition > 0 && newPosition < frame.width){
                    player.position.x = newPosition
                
                }
                
            }
        }
    }
    
    func getRandomTexture() -> SKTexture{
        let textures = ["redBall", "blueBall", "pinkBall", "cyanBall", "brownBall", "greenBall", "orangeBall", "neonBall", "greyBall", "redbrownBall", "whiteBall", "seafoamBall", "salmonBall", "paleblueBall", "tanBall", "palepinkBall", "lightgreenBall", "violetBall"]
        let randomTexture = SKTexture(imageNamed: textures.randomElement()!)
        return randomTexture
    }
    
    //the didBegin function is called when two bodies first contact each other
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        //if an enemy has made contact with the player,
        if firstBody.categoryBitMask == CollisionBitMask.playerCategory && secondBody.categoryBitMask == CollisionBitMask.enemyCategory {
            
            self.removeAllActions()
            
            //run the losing sound if the player has their sound set to on
            if soundOn {
                self.run(loseSound)
            }
                
            //if the player's score was >= 1, count this as a game played and
            //save it to the games played statistic
            if score >= 1 {
                if UserDefaults.standard.object(forKey: "gamesPlayed") != nil{
                    saveGamesPlayed()
                } else{
                    UserDefaults.standard.set(1, forKey: "gamesPlayed")
                }
            }
                
            //sends the score to game center and saves it within the app
            storeHighScore()
            
            //stores the jewels the player collected during the game
            storeJewels()
            
            //the game is over, set isDead to true
            isDead = true
            
            //creates pop up menu which allows the player to play again, view leaderboard,
            //go back to main screen, or view game unlocks. Stops player movement
            createRestartMenu()
            pauseBtn.removeFromParent()
            self.player.removeAllActions()
           
        }
            //else if the player collided with a yellow ball: run the score sound, have the yellow ball
            //explode into a random color, increase the game's difficulty, and add to their score
        else if firstBody.categoryBitMask == CollisionBitMask.playerCategory && secondBody.categoryBitMask == CollisionBitMask.scoreCategory {
            if !isDead {
                if soundOn {
                    run(scoreSound)
                }
                if let particles = SKEmitterNode(fileNamed: "Splash.sks") {
                    particles.position = secondBody.node!.position
                    particles.particleTexture = getRandomTexture()
                    addChild(particles)
                }
                
                increaseDifficulty()
                score += 1
                scoreLbl.text = "\(score)"
            }
            secondBody.node?.removeFromParent()
        }
            //else if the player collided with the edge of the box: run the buzzer sound, flash their screen,
            //and subtract a point from their score
        else if firstBody.categoryBitMask == CollisionBitMask.boxCategory && secondBody.categoryBitMask == CollisionBitMask.playerCategory {
            if !isDead {
                if soundOn{
                    run(buzzSound)
                }
                flashScreen()
                if score > 0 {
                    score -= 1
                    scoreLbl.text = "\(score)"
                }
            }
        }
            //else if the player collided with a jewel: run the jewel sound, add one to their jewel total
        else if firstBody.categoryBitMask == CollisionBitMask.playerCategory && secondBody.categoryBitMask == CollisionBitMask.jewelCategory {
            if !isDead {
                if soundOn{
                    run(jewelSound)
                }
                jewelsThisGame += 1
                jewelsTotalCount = jewelsThisGame + oldJewelsCount
                jewelsLbl.text = "\(jewelsTotalCount)"
                secondBody.node?.removeFromParent()
            }
        }
        
    }
    
}

//phone buzz
//AudioServicesPlaySystemSound(1519)
