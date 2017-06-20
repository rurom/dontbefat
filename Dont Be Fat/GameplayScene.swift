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
    
    private var healthBar: SKSpriteNode?
    private var healthBar1: SKSpriteNode?
    private var healthBar2: SKSpriteNode?
    
    private var dietBar: SKSpriteNode?
    private var dietBar1: SKSpriteNode?
    private var dietBar2: SKSpriteNode?
    
    private var center = CGFloat()
    
    private var canMove = false, moveLeft = false
    
    private var itemController = ItemController()
    
    private var scoreLbl: SKLabelNode?
    
    private var score = 0
    
    private var lives:Int = 3
    private var dietBonus:Int = 0
    
    private var itemsSpawnTimeInterval:TimeInterval = 1.0
    private let spawnKey = "SpawnKey"
    
    struct playerScoreData {
        static var currentPlayerScore: Int = 0
        static var highestPlayerScore: Int = 0
    }
    
//    let spawnNode = SKNode()
    
    override func didMove(to view: SKView) {
        
        initializeGame()
        
//        let wait = SKAction.wait(forDuration:TimeInterval(itemsSpawnTimeInterval))
//        let spawn = SKAction.run(spawnItems)
//        spawnNode.run(SKAction.repeatForever(SKAction.sequence([wait,spawn])))
//        addChild(spawnNode)
//        print(itemsSpawnTimeInterval)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        managePlayer()
        manageItemsSpawnSpeed()
    }
    
    
    func theCenter() {
        center = self.frame.size.width / self.frame.size.height
    }
    
    func scorePoints() {
        scoreLbl = childNode(withName: "scoreLbl") as? SKLabelNode!
        scoreLbl?.text = "0"
    }
    
    func manageItemsSpawnSpeed() {
        if score < 5 {
            itemsSpawnTimeInterval = TimeInterval(itemController.randomBetweenNumbers(firstNum: 1, secondNum: 1.5))
        } else if score >= 5 && score < 10 {
            itemsSpawnTimeInterval = TimeInterval(itemController.randomBetweenNumbers(firstNum: 0.9, secondNum: 1))
        } else if score >= 10 && score < 15 {
            itemsSpawnTimeInterval = TimeInterval(itemController.randomBetweenNumbers(firstNum: 0.8, secondNum: 0.9))
        } else if score >= 15 && score < 20 {
            itemsSpawnTimeInterval = TimeInterval(itemController.randomBetweenNumbers(firstNum: 0.7, secondNum: 0.8))
        } else if score >= 20 && score < 30 {
            itemsSpawnTimeInterval = TimeInterval(itemController.randomBetweenNumbers(firstNum: 0.6, secondNum: 0.7))
        } else if score >= 30 && score < 50 {
            itemsSpawnTimeInterval = TimeInterval(itemController.randomBetweenNumbers(firstNum: 0.5, secondNum: 0.6))
        } else if score >= 50 && score < 100 {
            itemsSpawnTimeInterval = TimeInterval(itemController.randomBetweenNumbers(firstNum: 0.4, secondNum: 0.5))
        } else if score >= 100 && score < 99999 {
            itemsSpawnTimeInterval = 0.4
        }
    }
    
    func manageHealthBars() {
        
        let healthBarCount = lives
        
        if healthBarCount == 3 {
            
            healthBar?.isHidden = false
            healthBar1?.isHidden = false
            healthBar2?.isHidden = false
        
        } else if healthBarCount == 2 {
            
            healthBar?.isHidden = false
            healthBar1?.isHidden = false
            healthBar2?.isHidden = true
           
        } else if healthBarCount == 1 {
            
            healthBar?.isHidden = false
            healthBar1?.isHidden = true
            healthBar2?.isHidden = true
            
        } else {
            healthBar?.isHidden = true
            healthBar1?.isHidden = true
            healthBar2?.isHidden = true
            
        }
        
    }
    
    func manageDietBonus () {
        if dietBonus == 0 {
            dietBar?.isHidden = true
            dietBar1?.isHidden = true
            dietBar2?.isHidden = true
        } else if dietBonus == 1 {
            dietBar?.isHidden = false
            dietBar1?.isHidden = true
            dietBar2?.isHidden = true
        } else if dietBonus == 2 {
            dietBar?.isHidden = false
            dietBar1?.isHidden = false
            dietBar2?.isHidden = true
        } else if dietBonus == 3 {
            dietBar?.isHidden = false
            dietBar1?.isHidden = false
            dietBar2?.isHidden = false
        }


    }
    
    func healthBarInit () {
        healthBar = childNode(withName: "healthBar") as? SKSpriteNode!
        healthBar1 = childNode(withName: "healthBar1") as? SKSpriteNode!
        healthBar2 = childNode(withName: "healthBar2") as? SKSpriteNode!
        
        healthBar!.zPosition = 3
        healthBar1!.zPosition = 3
        healthBar2!.zPosition = 3
        healthBar!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        healthBar1!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        healthBar2!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func dietBarInit () {
        dietBar = childNode(withName: "dietBonus") as? SKSpriteNode!
        dietBar1 = childNode(withName: "dietBonus1") as? SKSpriteNode!
        dietBar2 = childNode(withName: "dietBonus2") as? SKSpriteNode!
        
        dietBar?.isHidden = true
        dietBar1?.isHidden = true
        dietBar2?.isHidden = true
        
        dietBar!.zPosition = 3
        dietBar1!.zPosition = 3
        dietBar2!.zPosition = 3
        dietBar!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        dietBar1!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        dietBar2!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
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
    func theSpawner() {
        removeAction(forKey: spawnKey) // remove previous action if running.
        let spawnAction = SKAction.run(spawnItems)
        let spawnDelay = SKAction.wait(forDuration: itemsSpawnTimeInterval)
        let spawnSequence = SKAction.sequence([spawnAction, spawnDelay])
        run(SKAction.repeatForever(spawnSequence), withKey: spawnKey) // run action with key so you can cancel it later
    }
    //Food spawn timer for higher difficulty
    func theSpawntimer1() {
        manageItemsSpawnSpeed()
        Timer.scheduledTimer(timeInterval: TimeInterval(itemsSpawnTimeInterval), target: self, selector: #selector(GameplayScene.spawnItems), userInfo: nil, repeats: true)
        print(itemsSpawnTimeInterval)
    }
    
    //Food spawn timer for higher difficulty 2
    func theSpawntimer2() {
        manageItemsSpawnSpeed()
        Timer.scheduledTimer(timeInterval: TimeInterval(itemsSpawnTimeInterval), target: self, selector: #selector(GameplayScene.theSpawntimer1), userInfo: nil, repeats: true)
        print(itemsSpawnTimeInterval)
    }
    
    //Restart game timer
    func restartTimer() {
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameplayScene.gameOver), userInfo: nil, repeats: false)
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
            theSpawner()
            print("i have collided with HEALTHY!\(itemsSpawnTimeInterval)")
            
            
            if lives == 2 {
                dietBonus += 1
                manageDietBonus ()
                if dietBonus == 3 {
                     lives += 1
                     manageHealthBars()
                     dietBonus = 0
                     manageDietBonus ()
                    firstBody.node?.xScale = CGFloat(1.0)
                }
            } else if lives == 1 {
                    dietBonus += 1
                    manageDietBonus ()
                    if dietBonus == 3 {
                        lives += 1
                        print("Total lives =\(lives)")
                        manageHealthBars()
                        dietBonus = 0
                        manageDietBonus ()
                        firstBody.node?.xScale = CGFloat(2.0)
                    }
                }
            
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "boyPlayer" && secondBody.node?.name == "unhealthy" {
            print("oh SHIT!")
            
            if lives == 3 {
                lives -= 1
                manageHealthBars()
                dietBonus = 0
                manageDietBonus ()
                
                firstBody.node?.xScale = CGFloat(2.0)
            } else if lives == 2 {
                lives -= 1
                manageHealthBars()
                dietBonus = 0
                manageDietBonus ()
                firstBody.node?.xScale = CGFloat(2.8)
            } else {
                lives -= 1
                manageHealthBars()
                dietBonus = 0
                manageDietBonus ()
                print("GAME OVER")
                firstBody.node?.removeFromParent()
                secondBody.node?.removeFromParent()
                
                playerScoreData.currentPlayerScore = score
                
                restartTimer()
            }
            
        }
        
        if firstBody.node?.name == "girlPlayer" && secondBody.node?.name == "healthy" {
            score += 1
            scoreLbl?.text = String(score)
            theSpawner()
            print("i have collided with HEALTHY!")
            
            if lives == 2 {
                dietBonus += 1
                manageDietBonus ()
                if dietBonus == 3 {
                    lives += 1
                    print("Total lives =\(lives)")
                    manageHealthBars()
                    dietBonus = 0
                    manageDietBonus ()
                    firstBody.node?.xScale = CGFloat(1.0)
                }
            } else if lives == 1 {
                dietBonus += 1
                manageDietBonus ()
                if dietBonus == 3 {
                    lives += 1
                    print("Total lives =\(lives)")
                    manageHealthBars()
                    dietBonus = 0
                    manageDietBonus ()
                    firstBody.node?.xScale = CGFloat(2.0)
                }
            }
            
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "girlPlayer" && secondBody.node?.name == "unhealthy" {
            print("oh SHIT!")
            
            if lives == 3 {
                lives -= 1
                manageHealthBars()
                dietBonus = 0
                manageDietBonus ()
                firstBody.node?.xScale = CGFloat(2.0)
            } else if lives == 2 {
                lives -= 1
                manageHealthBars()
                dietBonus = 0
                manageDietBonus ()
                firstBody.node?.xScale = CGFloat(2.8)
            } else {
                lives -= 1
                manageHealthBars()
                dietBonus = 0
                manageDietBonus ()
                print("GAME OVER")
                firstBody.node?.removeFromParent()
                secondBody.node?.removeFromParent()
                
                playerScoreData.currentPlayerScore = score
                
                
                restartTimer()
            }

        }


    }

    private func initializeGame() {
        
        healthBarInit ()
        dietBarInit ()
        
        playerScoreData.currentPlayerScore = 0
        
        physicsWorld.contactDelegate = self
        
        if playerIndicator == 1 {
            player = childNode(withName: "boyPlayer") as? Player
            childNode(withName: "girlPlayer")?.isHidden = true
            theCenter()
            player?.initPlayer()
            scorePoints()
            theSpawner()
            removeItemsTimer()
        } else {
            if playerIndicator == 2 {
                player = childNode(withName: "girlPlayer") as? Player
                childNode(withName: "boyPlayer")?.isHidden = true
                theCenter()
                player?.initPlayer()
                scorePoints()
                theSpawner()
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
    
    func gameOver() {
        if let scene = ResultScreenScene(fileNamed:"ResultScreen") {
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
