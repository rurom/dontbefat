//
//  Player.swift
//  Dont Be Fat
//
//  Created by Roman on 5/10/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    private var minX = CGFloat(-204), maxX = CGFloat(204)
    
    func initPlayer() {
        if name == "boyPlayer" {
            physBody()
        }
        if name == "girlPlayer" {
            physBody()
        }
    }
    
    func physBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.height / 4)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollyderType.PLAYER
        physicsBody?.contactTestBitMask = CollyderType.FOOD

    }

    
    func move(left:Bool) {
        
        if left {
            position.x -= 15
            
            if position.x < minX {
                position.x = minX
            }
        } else {
            position.x += 15
            
            if position.x > maxX {
                position.x = maxX
            }
        }
    }
} //class
