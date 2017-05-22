//
//  MainMenuScene.swift
//  Dont Be Fat
//
//  Created by Roman on 5/7/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit

var playerIndicator:Int!

class MainMenuScene: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "boyBtn" {
                playerIndicator = 1
                if let scene = GameplayScene(fileNamed: "GamePlay") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
                }

                
            }else if atPoint(location).name == "girlBtn" {
                playerIndicator = 2
                if let scene = GameplayScene(fileNamed: "GamePlay") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
            
                }
            }
        }
    }
} //class
