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
    
    private var itemsSpawnTimeInterval:Float = 1.0
    
    struct playerScoreData {
        static var currentPlayerScore: Int = 0
        static var highestPlayerScore: Int = 0
    }
    
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
    
    func manageItemsSpawnSpeed() {
        if score < 3 {
            itemsSpawnTimeInterval = 1.1//Float(itemController.randomBetweenNumbers(firstNum: 1, secondNum: 2))
        } else if score >= 3 && score < 6 {
            itemsSpawnTimeInterval = 0.9
        } else if score >= 6 && score < 9 {
            itemsSpawnTimeInterval = 0.8
        } else if score >= 9 && score < 12 {
            itemsSpawnTimeInterval = 0.7
        } else if score >= 12 && score < 15 {
            itemsSpawnTimeInterval = 0.6
        } else if score >= 15 && score < 18 {
            itemsSpawnTimeInterval = 0.5
        } else if score >= 18 && score < 21 {
            itemsSpawnTimeInterval = 0.4
        } else if score >= 21 && score < 99999 {
            itemsSpawnTimeInterval = 0.3
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
    func theSpawntimer() {
        Timer.scheduledTimer(timeInterval: TimeInterval(1.5), target: self, selector: #selector(GameplayScene.spawnItems), userInfo: nil, repeats: true)
    }
    //Food spawn timer for higher difficulty
    func theSpawntimer1() {
        manageItemsSpawnSpeed()
        Timer.scheduledTimer(timeInterval: TimeInterval(itemsSpawnTimeInterval), target: self, selector: #selector(GameplayScene.spawnItems), userInfo: nil, repeats: false)
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
            theSpawntimer2()
            removeItemsTimer()
        } else {
            if playerIndicator == 2 {
                player = childNode(withName: "girlPlayer") as? Player
                childNode(withName: "boyPlayer")?.isHidden = true
                theCenter()
                player?.initPlayer()
                scorePoints()
                theSpawntimer2()
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
