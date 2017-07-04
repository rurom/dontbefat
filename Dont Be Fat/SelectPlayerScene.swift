//
//  SelectPlayerScene.swift
//  Dont Be Fat
//
//  Created by Roman on 5/7/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit

public var playerIndicator:Int!
private var kitchenBg: SKSpriteNode?
private var txtSelectLbl: SKLabelNode?
private var txtPlayerLbl: SKLabelNode?
private var girlPlayerBtn: SKSpriteNode?
private var boyPlayerBtn: SKSpriteNode?
private var backToMenu: SKSpriteNode?


class SelectPlayerScene: SKScene {
    
    
    
    override func didMove(to view: SKView) {
        
        kitchenBg = childNode(withName: "kitchenBg") as? SKSpriteNode
        girlPlayerBtn = childNode(withName: "girlBtn") as? SKSpriteNode
        boyPlayerBtn = childNode(withName: "boyBtn") as? SKSpriteNode
        backToMenu = childNode(withName: "backToMenuBtn") as? SKSpriteNode
        txtSelectLbl = childNode(withName: "txtSelectLbl") as? SKLabelNode
        txtPlayerLbl = childNode(withName: "txtPlayerLbl") as? SKLabelNode
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "boyBtn" {
                playerIndicator = 1
                if let scene = GameplayScene(fileNamed: "GamePlay") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(1.5)))
                }

                
            }else if atPoint(location).name == "girlBtn" {
                playerIndicator = 2
                if let scene = GameplayScene(fileNamed: "GamePlay") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
                }
                
            }else if atPoint(location).name == "backToMenuBtn" {
                    if let scene = MainMenuScene(fileNamed: "MainMenu") {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        
                        // Present the scene
                        view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))
                }
            }
        }
    }
    
} //class
