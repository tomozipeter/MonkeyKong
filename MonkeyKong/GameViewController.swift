//
//  GameViewController.swift
//  MonkeyKong
//
//  Created by Tomozi Peter on 2019. 05. 29..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    
    @IBOutlet weak var angleSlider: UISlider!
    
    @IBOutlet weak var angleLabel: UILabel!
    
    @IBOutlet weak var velocitySlider: UISlider!
    
    @IBOutlet weak var velocityLabel: UILabel!
    
    @IBOutlet weak var playerNumber: UILabel!
    
    @IBOutlet weak var lanunchButton: UIButton!
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))"
    }
    
    var hiddenControls: Bool  {
        get {
           return angleLabel.isHidden
        }
        set(newValue) {
            angleLabel.isHidden = newValue
            angleSlider.isHidden = newValue
            velocityLabel.isHidden = newValue
            velocitySlider.isHidden = newValue
            lanunchButton.isHidden = newValue
            playerNumber.isHidden = newValue
        }
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        gameScene?.activePlayer.angle = angleSlider.value
        gameScene?.activePlayer.velocity = velocitySlider.value
        hiddenControls = true
        
        gameScene?.launch(Int(angleSlider.value), Int(velocitySlider.value))
        
    }
    func activatePlayer(player: Player) {
        if player.playerType == .player1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        angleSlider.value = player.angle
        velocitySlider.value = player.velocity
        hiddenControls = false
    }
    
    
    weak var gameScene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                
                view.presentScene(scene)
                if let ourGameScene = scene as? GameScene {
                    ourGameScene.viewController = self
                    gameScene = ourGameScene
                }
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        //default text
        angleChanged(self)
        velocityChanged(self)
        activatePlayer(player: gameScene!.activePlayer!)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
