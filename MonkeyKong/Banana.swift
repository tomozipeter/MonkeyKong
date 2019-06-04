//
//  Banana.swift
//  MonkeyKong
//
//  Created by Tomozi Peter on 2019. 05. 31..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit

class Banana: SKSpriteNode {
    
    static public func getName() -> String {
        return "banana"
    }
    
    init() {
        let texture = SKTexture(imageNamed: "banana")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        name = Banana.getName()
        
        physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width / 2.0)
        physicsBody?.categoryBitMask = BitMask.Banana
        physicsBody?.collisionBitMask = BitMask.Building | BitMask.Player
        physicsBody?.contactTestBitMask = BitMask.Building | BitMask.Player
        physicsBody?.isDynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
