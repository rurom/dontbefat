//
//  GameplayScene.swift
//  Dont Be Fat
//
//  Created by Roman on 5/7/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit

class GameplayScene:SKScene, SKPhysicsContactDelegate {
    
    private var player: Player?
    
    private var center = CGFloat()
    
    private var canMove = false, moveLeft = false
    
    private var itemController = ItemController()
    
    private var scoreLbl: SKLabelNode?
    
    private var score = 0
    
    
    override func didMove(to view: SKView) {
        
        initializeGame()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        managePlayer()
    }
    
    
    func theCenter() {
        center = self.frame.size.width / self.frame.size.height
    }
    
    func scorePoints() {
        scoreLbl = childNode(withName: "scoreLbl") as? SKLabelNode!
        scoreLbl?.text = "0"
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if location.x > center {
                moveLeft = false
            } else {
                moveLeft = true
            }
            
        }
        canMove = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMove = false
    }
    
    //Food items spawn timer
    func theSpawntimer() {
        Timer.scheduledTimer(timeInterval: TimeInterval(itemController.randomBetweenNumbers(firstNum: 1, secondNum: 3)), target: self, selector: #selector(GameplayScene.spawnItems), userInfo: nil, repeats: true)
    }
    
    //Restart game timer
    func restartTimer() {
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameplayScene.restartGame), userInfo: nil, repeats: false)
    }
    
    //Remove items timer
    func removeItemsTimer() {
        Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(GameplayScene.removeItems), userInfo: nil, repeats: true)
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        
        if contact.bodyA.node?.name == "boyPlayer" || contact.bodyA.node?.name == "girlPlayer" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if firstBody.node?.name == "boyPlayer" && secondBody.node?.name == "healthy" {
            score += 1
            scoreLbl?.text = String(score)
            print("i have collided with HEALTHY!")
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "boyPlayer" && secondBody.node?.name == "unhealthy" {
            print("oh SHIT!")
            
            //firstBody.node?.removeFromParent()
            //secondBody.node?.removeFromParent()
            
            restartTimer()
        }
        
        if firstBody.node?.name == "girlPlayer" && secondBody.node?.name == "healthy" {
            score += 1
            scoreLbl?.text = String(score)
            print("i have collided with HEALTHY!")
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "girlPlayer" && secondBody.node?.name == "unhealthy" {
            print("oh SHIT!")
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            
            restartTimer()
        }


    }

    private func initializeGame() {
        
        physicsWorld.contactDelegate = self
        
        if playerIndicator == 1 {
            player = childNode(withName: "boyPlayer") as? Player
            childNode(withName: "girlPlayer")?.isHidden = true
            theCenter()
            player?.initPlayer()
            scorePoints()
            theSpawntimer()
            removeItemsTimer()
        } else {
            if playerIndicator == 2 {
                player = childNode(withName: "girlPlayer") as? Player
                childNode(withName: "boyPlayer")?.isHidden = true
                theCenter()
                player?.initPlayer()
                scorePoints()
                theSpawntimer()
                removeItemsTimer()
            }
        }
        
    }

    private func managePlayer() {
        
        if canMove {
            player?.move(left: moveLeft)
        }
    }
    
    
    func spawnItems() {
        self.scene?.addChild(itemController.spawnItems())
    }
    
    func restartGame() {
        if let scene = GameplayScene(fileNamed:"GamePlay") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: SKTransition.flipVertical(withDuration: TimeInterval(2)))
        }
    }
    
    func removeItems() {
        for child in children {
            if child.name == "healthy" || child.name == "unhealthy" {
                if child.position.y < -self.scene!.frame.height - 100 {
                    child.removeFromParent()
                }
            }
        }
    }
    
} //class
