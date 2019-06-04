//
//  Player.swift
//  MonkeyKong
//
//  Created by Tomozi Peter on 2019. 05. 31..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var velocity: Float = 125
    var angle: Float = 45
    
    
    let playerType: GamePlayer
    public var building: BuildingNode? {
        didSet {
            if let mybuilding = building {
            let topOfbuilidng = CGPoint(x:  mybuilding.position.x + 10,
                                        y:  mybuilding.position.y +
                                            (mybuilding.size.height + self.size.height) / 2.0)
            self.position = topOfbuilidng
            }
        }
    }
    public var throwing: Bool = false {
        didSet {
            var textureName = "player"
            if throwing {
                if playerType == .player1 {
                    textureName = "player1Throw"
                } else {
                    textureName = "player2Throw"
                }
            } 
            let newTexture = SKTexture(imageNamed: textureName)
            texture = newTexture
        }
    }
    
    init(_ player: GamePlayer) {
        let texture = SKTexture(imageNamed: "player")
        playerType = player
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        zPosition = 2
        name = player.getName()
        
        physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width / 2.0)
        physicsBody?.categoryBitMask = BitMask.Player
        physicsBody?.collisionBitMask = BitMask.Banana
        physicsBody?.contactTestBitMask = BitMask.Banana
        physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
