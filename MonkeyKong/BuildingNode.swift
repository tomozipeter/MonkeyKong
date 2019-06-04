//
//  BuildingNode.swift
//  MonkeyKong
//
//  Created by Tomozi Peter on 2019. 05. 29..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit
import UIKit

class BuildingNode : SKSpriteNode {
    
    var currentImage: UIImage!
    var explodeY: CGFloat = 0
    static let nodeName = "Building"
    
    func setup() {
        name = BuildingNode.nodeName
        currentImage = drawBuildingToImage(size: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = BitMask.Building
        physicsBody?.contactTestBitMask = BitMask.Banana
        
    }
    
    func drawBuildingToImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: 2.0, dy: 2.0)
            let color: UIColor = GameLogic.getRandomColor()
            color.setFill()
            context.cgContext.addRect(rectangle)
            context.cgContext.drawPath(using: .fill)
            
            let lightOnColor = UIColor(hue: 0.19, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            // size.width 20+(35n)
            let border = (size.width -  CGFloat(size.width / 35.0).rounded(.down) * 35.0)/2.0
            for row in stride(from: 10, through: Int(size.height - 10), by: 40) {
                for col in stride(from: Int(border), through: Int(size.width - border - 34), by: 35) {
                    let windowRect = CGRect(x: col+10, y: row, width: 15, height: 20)
                    UIColor.black.setFill()
                    context.cgContext.fill(windowRect)
                    
                    let lightOn = Bool.random()
                    if lightOn {
                        lightOnColor.setFill()
                    } else {
                        lightOffColor.setFill()
                    }
                    
                    context.cgContext.fill(windowRect.insetBy(dx: 2, dy: 2))
                }
            }
            
            
            
        }
        return image
    }
    
    func hitAt(point: CGPoint) {
        let convertedPoint = CGPoint(x: point.x + size.width / 2.0, y: abs(point.y - (size.height / 2.0)))
        var explodeMuliplier: CGFloat = 1.0
        if explodeY == 0 {
            explodeY = convertedPoint.y
        } else if convertedPoint.y <= explodeY {
            explodeY = convertedPoint.y
            explodeMuliplier = 1.5
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            currentImage.draw(at: CGPoint(x: 0, y: 0))
            let explodeSize = GameLogic.randomCGFloat(40.0, 80.0) * explodeMuliplier
            
            ctx.cgContext.addEllipse(in: CGRect(x: convertedPoint.x - 32, y: convertedPoint.y - 32, width: explodeSize, height: explodeSize))
            ctx.cgContext.setBlendMode(.clear)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        texture = SKTexture(image: img)
        currentImage = img
        
        configurePhysics()
    }
}
