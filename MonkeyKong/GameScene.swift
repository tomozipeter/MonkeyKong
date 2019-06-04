//
//  GameScene.swift
//  MonkeyKong
//
//  Created by Tomozi Peter on 2019. 05. 29..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var buildings = [BuildingNode]()
    weak var viewController: GameViewController?
    var player1: Player!
    var player2: Player!
    var banana: Banana?
    var activePlayer: Player! {
        didSet {
            viewController?.activatePlayer(player: activePlayer)
        }
    }
    func changePlayer() {
        if activePlayer == player1 {
            activePlayer = player2
        } else {
            activePlayer = player1
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        createEnvironment()
        createPlayers()
        activePlayer = player1
    }
    func createEnvironment() {
        var buildingLeftCorner:CGFloat = -5.0
        
        while buildingLeftCorner < size.width {
            let buildingHeight = GameLogic.randomCGFloat(200, 600)
            let buildingWidth = GameLogic.randomCGFloat(100, 300)
            
            let build = BuildingNode()
            build.size = CGSize(width: buildingWidth, height: buildingHeight)
            build.position = CGPoint(x: buildingLeftCorner + (build.size.width / 2), y: build.size.height / 2)
            build.setup()
            addChild(build)
            buildings.append(build)
            buildingLeftCorner += buildingWidth
        }
    }
    func createPlayers() {
        player1 = Player(.player1)
        player1.building = buildings[0]
        addChild(player1)
        
        player2 = Player(.player2)
        if buildings[buildings.count-1].position.x < size.width - 60 {
            player2.building = buildings[buildings.count-1]
            
        } else {
            player2.building = buildings[buildings.count-2]
        }
        
        addChild(player2)
        player2.throwing = false
        
    }
    
    override func didSimulatePhysics() {
        //Tells your app to peform any necessary logic after physics simulations are performed.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if let activeBanana = banana {
            if activeBanana.position.y < -1000.0 {
                activeBanana.removeFromParent()
                banana = nil
                
                changePlayer()
            }
        }
    }
    
    public func launch(_ angle: Int,_ velocity: Int) {
        if banana != nil {
            banana?.removeFromParent()
            banana = nil
        }
        
        activePlayer.throwing = true
        let speed = Double(velocity) / 10.0
        var impulse: CGVector
        let radian = GameLogic.deg2rad(angle)
        
        banana = Banana()
        
        if activePlayer == player1 {
            banana?.position = CGPoint(x:  activePlayer.position.x - 30, y: activePlayer.position.y + 40)
            banana?.physicsBody?.angularVelocity = -20
            impulse = CGVector(dx: cos(radian) * speed, dy: sin(radian) * speed)
        } else {
            banana?.position = CGPoint(x:  activePlayer.position.x + 30, y: activePlayer.position.y + 40)
            banana?.physicsBody?.angularVelocity = 20
            impulse = CGVector(dx: cos(radian) * -speed, dy: sin(radian) * speed)
         
        }
        let handsUp = SKAction.run {
            self.activePlayer.throwing = true
        }
        let handsDown = SKAction.run {
            self.activePlayer.throwing = false
        }
        let sequence = SKAction.sequence([handsUp,
            SKAction.wait(forDuration: 0.5),
            handsDown])
        activePlayer.run(sequence)
        addChild(banana!)

        banana?.physicsBody?.applyImpulse(impulse)
        
        
        //if activePlayer == player1 {
        //    activePlayer = player2
        //} else {
        //    activePlayer = player1
        //}
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if let firstNode = firstBody.node {
            if let secondNode = secondBody.node {
                if firstNode.name == Banana.getName() && secondNode.name == BuildingNode.nodeName {
                    bananaHit(building: secondNode as! BuildingNode, atPoint: contact.contactPoint)
                }
                
                if firstNode.name == Banana.getName() && secondNode.name == GamePlayer.player1.getName() {
                    destroy(player: player1)
                }
                
                if firstNode.name == Banana.getName() && secondNode.name == GamePlayer.player2.getName() {
                    destroy(player: player2)
                }
            }
        }
    }
    
    func destroy(player: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "hitPlayer")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        banana?.removeFromParent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.gameScene = newGame
            
            self.changePlayer()
            newGame.activePlayer = self.activePlayer
            
            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
    func bananaHit(building: BuildingNode, atPoint contactPoint: CGPoint) {
        let buildingLocation = convert(contactPoint, to: building)
        building.hitAt(point: buildingLocation)
        
        let explosion = SKEmitterNode(fileNamed: "hitBuilding")!
        explosion.position = contactPoint
        addChild(explosion)
        
        banana?.name = ""
        banana?.removeFromParent()
        banana = nil
        
        changePlayer()
    }
    
}
