//
//  ResultScreenScene.swift
//  Dont Be Fat
//
//  Created by Roman on 6/12/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//


import SpriteKit

private var currentScoreLbl: SKLabelNode?
private var highestScoreLbl: SKLabelNode?
private var txtCurrentScoreLbl: SKLabelNode?
private var txtHighestScoreLbl: SKLabelNode?
private var playAgain: SKSpriteNode?
private var backToMenu: SKSpriteNode?


class ResultScreenScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        currentScoreLbl = childNode(withName: "currentScoreLbl") as? SKLabelNode
        highestScoreLbl = childNode(withName: "highestScoreLbl") as? SKLabelNode
        txtCurrentScoreLbl = childNode(withName: "txtCurrentScoreLbl") as? SKLabelNode
        txtHighestScoreLbl = childNode(withName: "txtHighestScoreLbl") as? SKLabelNode
        backToMenu = childNode(withName: "backToMenuBtn") as? SKSpriteNode
        playAgain = childNode(withName: "playAgainBtn") as? SKSpriteNode
        
        let currentScore = GameplayScene.playerScoreData.currentPlayerScore
        //var highestScore = GameplayScene.playerScoreData.highestPlayerScore
        
        if currentScore > GameplayScene.playerScoreData.highestPlayerScore {
            GameplayScene.playerScoreData.highestPlayerScore = currentScore        }
        
        currentScoreLbl?.text = String(currentScore)
        highestScoreLbl?.text = String(GameplayScene.playerScoreData.highestPlayerScore)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "backToMenuBtn" {
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(1)))
                }
            } else if atPoint(location).name == "playAgainBtn" {
               
                if let scene = GameplayScene(fileNamed: "GamePlay") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(1)))
                }
            }
        }
    }
    
} // class
