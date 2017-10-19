//
//  MainMenuScene.swift
//  Dont Be Fat
//
//  Created by Roman on 6/1/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit



class MainMenuScene: SKScene {
    
    private var playBtn:SKSpriteNode?
    private var highscoresBtn:SKSpriteNode?
    private var rulesBtn:SKSpriteNode?
    private var settingsBtn:SKSpriteNode?
    private var marker:String = ""
    
    
    override func didMove(to view: SKView) {
        
        playBtn = childNode(withName: "playBtn") as? SKSpriteNode!
        highscoresBtn = childNode(withName: "highscoresBtn") as? SKSpriteNode!
        rulesBtn = childNode(withName: "rulesBtn") as? SKSpriteNode!
        settingsBtn = childNode(withName: "settingsBtn") as? SKSpriteNode!

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "playBtn" {
                
                if let scene = SelectPlayerScene(fileNamed: "SelectPlayer") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))
                }
                
                
            } else if atPoint(location).name == "highscoresBtn" {
                
                marker = "highscores"
                internetReachability ()
                
                
            }else if atPoint(location).name == "rulesBtn" {
                
                if let scene = RulesScene(fileNamed: "Rules") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))
                }
            } else if atPoint(location).name == "settingsBtn" {
                
                marker = "settings"
                internetReachability ()
            }

        }
    }
    
    
    

    //Check the internet reachability
    func internetReachability () {
        
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
        let alertController = UIAlertController(title: "", message: "Please, check your internet connection", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }

    func goSettings () {
        
        if let scene = SettingsScene(fileNamed: "Settings") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))
            
        }
    }
    
    func goHighscores () {
        if let scene = HighscoresScene(fileNamed: "Highscores") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(0.02))) }
    }
    
    func goToScene() {
        if self.marker == "settings" {
            self.goSettings()
        }
        if self.marker == "highscores" {
            goHighscores()
        }
    }

} //class
