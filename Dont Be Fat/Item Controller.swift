//
//  Item Controller.swift
//  Dont Be Fat
//
//  Created by Roman on 5/12/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit

struct CollyderType {
    
    static let PLAYER:UInt32 = 0
    static let FOOD:UInt32 = 1
    
}

class ItemController {
    
    private var minX = CGFloat(-204), maxX = CGFloat(204)
    
    func spawnItems() -> SKSpriteNode {
        
        let item:SKSpriteNode?
        let randonNum:UInt32 = arc4random_uniform(3)
        
        
        if randonNum > 1 {
            let randomHealthy:UInt32 = arc4random_uniform(14)
            
            item = SKSpriteNode(imageNamed: "healthy \(randomHealthy)")
            item!.name = "healthy"
            item!.physicsBody = SKPhysicsBody(circleOfRadius: item!.size.height / 2)
            
        } else {
            let randomUnhealthy:UInt32 = arc4random_uniform(18)
            
            item = SKSpriteNode(imageNamed: "unhealthy \(randomUnhealthy)")
            item!.name = "unhealthy"
            item!.physicsBody = SKPhysicsBody(circleOfRadius: item!.size.height / 2)
        }
        
        item!.physicsBody?.categoryBitMask = CollyderType.FOOD //1
        item!.physicsBody?.contactTestBitMask = CollyderType.PLAYER
        item!.zPosition = 3
        item!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        item!.setScale(0.6)
        
        item!.position.x = randomBetweenNumbers(firstNum: -205, secondNum: 205)
        item!.position.y = randomBetweenNumbers(firstNum: -15, secondNum: 365)
        
        return item!
    }
    
    func randomBetweenNumbers(firstNum:CGFloat, secondNum:CGFloat) -> CGFloat {
        
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs (firstNum - secondNum) + min(firstNum, secondNum)
    }
    
} //class
