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
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(1)))
                }
                
                
            } else if atPoint(location).name == "highscoresBtn" {
                
                if let scene = HighscoresScene(fileNamed: "Highscores") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(1))) }
                
            }else if atPoint(location).name == "rulesBtn" {
                
                if let scene = RulesScene(fileNamed: "Rules") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(1)))
                }
            } else if atPoint(location).name == "settingsBtn" {
                
                if let scene = SettingsScene(fileNamed: "Settings") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(1)))
                }
            }

        }
    }

} //class
