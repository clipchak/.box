//
//  Settings.swift
//  box
//
//  Created by Colton Lipchak on 5/15/19.
//  Copyright © 2019 clipchak. All rights reserved.
//

import SpriteKit
import GameKit


var safeAreaBottom = CGFloat(0.0)
var safeAreaLeft = CGFloat(0.0)
var safeAreaRight = CGFloat(0.0)
var safeAreaTop = CGFloat(0.0)
var soundOn = true

func saveHighscore(gameScore: Int, boardId: String){
    if GKLocalPlayer.local.isAuthenticated{
        print("\n Success! Sending highscore of \(gameScore) to leaderboard")
        
        let leaderboard_id = boardId
        let scoreReporter = GKScore(leaderboardIdentifier: leaderboard_id)
        
        scoreReporter.value = Int64(gameScore)
        let scoreArray: [GKScore] = [scoreReporter]
        
        GKScore.report(scoreArray, withCompletionHandler: {Error -> Void in
            if Error != nil {
                print("an error has occurred")
                //print("\n \(Error) \n")
            }
        })
    }
}

func saveGamesPlayed(){
    var gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")
    gamesPlayed += 1
    UserDefaults.standard.set(gamesPlayed, forKey: "gamesPlayed")
}

struct CollisionBitMask{
    static let groundCategory: UInt32 = 0x1 << 1
    static let playerCategory: UInt32 = 0x1 << 2
    static let enemyCategory:  UInt32 = 0x1 << 3
    static let scoreCategory:  UInt32 = 0x1 << 4
    static let jewelCategory:  UInt32 = 0x1 << 5
    static let boxCategory:    UInt32 = 0x1 << 6
}

extension UIColor {
    struct MyTheme {
        static var boxColor: UIColor  { return UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1) }
        static var bgColor: UIColor  { return UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1) }
   
    }
}
