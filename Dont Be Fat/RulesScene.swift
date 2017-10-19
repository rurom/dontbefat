//
//  RulesScene.swift
//  Dont Be Fat
//
//  Created by Roman on 6/10/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit

private var rulesPage1: SKSpriteNode?
private var rulesPage2: SKSpriteNode?
private var rulesPage3: SKSpriteNode?

private var backToMenu: SKSpriteNode?
private var startGame: SKSpriteNode?


private var rulesPageNumber:Int = 1


class RulesScene: SKScene {
        
        
        override func didMove(to view: SKView) {
            
            rulesPage1 = childNode(withName: "rules1") as? SKSpriteNode
            rulesPage2 = childNode(withName: "rules2") as? SKSpriteNode
            rulesPage3 = childNode(withName: "rules3") as? SKSpriteNode
            backToMenu = childNode(withName: "backToMenuBtn") as? SKSpriteNode
            startGame = childNode(withName: "startGameBtn") as? SKSpriteNode
            
            rulesPageNumber = 1
            
            checkCurrentRulesPage()
            
            let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(RulesScene.swipedRight))
            swipeRight.direction = .right
            view.addGestureRecognizer(swipeRight)
            
            let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(RulesScene.swipedLeft))
            swipeLeft.direction = .left
            view.addGestureRecognizer(swipeLeft)
            
        }
    
    
        @objc func swipedRight(sender: UISwipeGestureRecognizer) {
            
            if rulesPageNumber > 1 {
                rulesPageNumber-=1
            }
            checkCurrentRulesPage()
            print("SWIPE RIGHT")
            
        }
    
        @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        
            if rulesPageNumber < 3 {
                rulesPageNumber+=1
            }
           checkCurrentRulesPage()
           print("SWIPE LEFT")
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "backToMenuBtn" {
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))
                }
                
                
            } else if atPoint(location).name == "startGameBtn" {
                if let scene = SelectPlayerScene(fileNamed: "SelectPlayer") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))
                    
                }
            }
        }
    }

    
   func checkCurrentRulesPage() {
    
    if rulesPageNumber == 1 {
    rulesPage1?.isHidden = false
    rulesPage2?.isHidden = true
    rulesPage3?.isHidden = true
    backToMenu?.isHidden = false
    startGame?.isHidden = true
    
    } else if rulesPageNumber == 2 {
    
    rulesPage1?.isHidden = true
    rulesPage2?.isHidden = false
    rulesPage3?.isHidden = true
    backToMenu?.isHidden = true
    startGame?.isHidden = true
    
    } else if rulesPageNumber == 3 {
    rulesPage1?.isHidden = true
    rulesPage2?.isHidden = true
    rulesPage3?.isHidden = false
    backToMenu?.isHidden = true
    startGame?.isHidden = false
    }
    
    }
    
    
} //class
