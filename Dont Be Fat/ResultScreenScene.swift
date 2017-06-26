//
//  ResultScreenScene.swift
//  Dont Be Fat
//
//  Created by Roman on 6/12/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//


import SpriteKit
import Firebase
import FBSDKLoginKit

private var currentScoreLbl: SKLabelNode?
private var highestScoreLbl: SKLabelNode?
private var txtCurrentScoreLbl: SKLabelNode?
private var txtHighestScoreLbl: SKLabelNode?
private var playAgain: SKSpriteNode?
private var backToMenu: SKSpriteNode?
private var highestScore:String?


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
            GameplayScene.playerScoreData.highestPlayerScore = currentScore
        }
            // adding a reference to firebase database
            let ref = FIRDatabase.database().reference(fromURL: "https://dont-be-fat-a6f79.firebaseio.com/")
            // create a child reference - uid will let us wrap each users data in a unique user id for later reference
            let uid = FIRAuth.auth()?.currentUser?.uid
            let usersReference = ref.child("users").child(uid!)
            
            usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String:AnyObject] {
                   highestScore = dictionary ["highestScore"] as? String
                }
            
            print(highestScore ?? "")
            print(GameplayScene.playerScoreData.highestPlayerScore)
            
            if Int(highestScore!)! > GameplayScene.playerScoreData.highestPlayerScore {
                GameplayScene.playerScoreData.highestPlayerScore = Int(highestScore!)!
                self.printResults()
            } else {
                self.printResults()
            let bestScore:String = (String(GameplayScene.playerScoreData.highestPlayerScore))
            
            let values = ["highestScore":bestScore]
            
            // update our databse by using the child database reference above called usersReference
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                // if there's an error in saving to our firebase database
                if err != nil {
                    print(err ?? "")
                    return
                }
                // no error, so it means we've saved the user into our firebase database successfully
                print("Save the SCORE successfully into Firebase database")
                
             })
                }

          })
            
        }
        
    
    
    func printResults() {
        currentScoreLbl?.text = String(GameplayScene.playerScoreData.currentPlayerScore)
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
