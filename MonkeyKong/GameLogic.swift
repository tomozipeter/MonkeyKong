//
//  GameLogic.swift
//  MonkeyKong
//
//  Created by Tomozi Peter on 2019. 05. 30..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit
import UIKit

struct BitMask {
    static let Banana: UInt32 = 0x1 << 0
    static let Building: UInt32 = 0x1 << 1
    static let Player: UInt32 = 0x1 << 2
    //static let Wall: UInt32 = 0x1 << 2
}

enum GamePlayer: Int {
    case player1
    case player2
    
    func getName() -> String {
        switch self {
        case .player1: return "player1"
        case .player2: return "player2"
        }
    }
}

enum GameState {
    case process
    case waitToStart
}

class GameLogic {
    
    static public func randomCGFloat(_ lowerLimit: CGFloat, _ upperLimit: CGFloat) -> CGFloat {
        //return CGFloat.random(in: Double(lowerLimit) ... Double(upperLimit))
        return lowerLimit + CGFloat(arc4random()) / CGFloat(UInt32.max) * (upperLimit - lowerLimit)
    }
    
    static public func getVector(withSpeed speed:CGFloat,withAngle angle:CGFloat) -> CGVector {
        let dx = speed * cos(angle)
        let dy = speed * sin(angle)
        return CGVector(dx: dx, dy: dy)
    }
    
    static public func getRandomColor() -> UIColor {
        return UIColor(red: randomCGFloat(0.0,1.0),
                       green: randomCGFloat(0.0,1.0),
                       blue: randomCGFloat(0.0,1.0),
                       alpha: 1)
    }
    
    static public func deg2rad(_ degrees:Int) -> Double {
        return Double(degrees) * .pi / 180.0
    }
    
}
