//
//  HighscoresScene.swift
//  Dont Be Fat
//
//  Created by Roman on 6/10/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit

private var backToMenu: SKSpriteNode?

class HighscoresScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        backToMenu = childNode(withName: "backToMenuBtn") as? SKSpriteNode
        
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
                
                
            }
        }
    }

    

} // class
