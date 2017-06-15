//
//  LoginScene.swift
//  Dont Be Fat
//
//  Created by Roman on 6/13/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit


class LoginScene: SKScene {
    
    private var loginBg:SKSpriteNode?
    private var fbLoginBtn:SKSpriteNode?
    
    
    override func didMove(to view: SKView) {
        
        loginBg = childNode(withName: "loginBg") as? SKSpriteNode!
        fbLoginBtn = childNode(withName: "fbLoginBtn") as? SKSpriteNode!
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "fbLoginBtn" {
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(1)))
                }
            }
        }
    }
    
} //class

