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
private var highestScore:Int?
private var marker:String = ""


class ResultScreenScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        currentScoreLbl = childNode(withName: "currentScoreLbl") as? SKLabelNode
        highestScoreLbl = childNode(withName: "highestScoreLbl") as? SKLabelNode
        txtCurrentScoreLbl = childNode(withName: "txtCurrentScoreLbl") as? SKLabelNode
        txtHighestScoreLbl = childNode(withName: "txtHighestScoreLbl") as? SKLabelNode
        backToMenu = childNode(withName: "backToMenuBtn") as? SKSpriteNode
        playAgain = childNode(withName: "playAgainBtn") as? SKSpriteNode
        
        let currentScore = GameplayScene.playerScoreData.currentPlayerScore
        
        if currentScore > GameplayScene.playerScoreData.highestPlayerScore {
            GameplayScene.playerScoreData.highestPlayerScore = currentScore
        }
            // adding a reference to firebase database
        let ref = Database.database().reference(fromURL: "https://dont-be-fat-a6f79.firebaseio.com/")
            // create a child reference - uid will let us wrap each users data in a unique user id for later reference
        let uid = Auth.auth().currentUser?.uid
            let usersReference = ref.child("users").child(uid!)
            
            usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String:AnyObject] {
                   highestScore = dictionary ["highestScore"] as? Int
                }
            
            print(highestScore ?? "")
            print(GameplayScene.playerScoreData.highestPlayerScore)
            
            if highestScore! > GameplayScene.playerScoreData.highestPlayerScore {
                GameplayScene.playerScoreData.highestPlayerScore = highestScore!
                self.printResults()
            } else {
                self.printResults()
            let bestScore:Int = GameplayScene.playerScoreData.highestPlayerScore
            
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
                marker = "backToMenu"
                internetReachability()
                
            } else if atPoint(location).name == "playAgainBtn" {
               marker = "playAgain"
               internetReachability()
            }
        }
    }
    
    //Check the internet reachability
    func internetReachability() {
        
        let reachability =  InternetReachability()!
        //reachability.isReachable is deprecated, right solution --> connection != .none
        if reachability.connection != .none {
            //reachability.isReachableViaWiFi is deprecated, right solution --> connection == .wifi
            if reachability.connection == .wifi {
                DispatchQueue.main.async {
                    print("Internet via WIFI is OK!")
                    self.goToScene()
                }
                
            } else {
                DispatchQueue.main.async {
                    print("Internet via Cellular is OK!")
                    self.goToScene()
                }
            }
        } else {
            
            print("Please check your Internet connection!")
            inetAlert()
        }
    }
    
    func inetAlert() {
        //Alert Pop-up no internet connection
        let alertController = UIAlertController(title: "", message: "Your result can not be saved! Please, check your internet connection!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    func goBackToMenu() {
        if let scene = MainMenuScene(fileNamed: "MainMenu") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))
        }
    }
    
    func goPlayAgain() {
        if let scene = GameplayScene(fileNamed: "GamePlay") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))
        }
    }
    
    func goToScene() {
        if marker == "backToMenu" {
            goBackToMenu()
        }
        if marker == "playAgain" {
            goPlayAgain()
        }
    }
    
} // class
