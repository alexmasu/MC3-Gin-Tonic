//
//  SKscene+background.swift
//  MC3-Gin-Tonic
//
//  Created by Alessandro Masullo on 23/02/22.
//

import SpriteKit

extension SKScene {
    func makeBackground() {
        if let starsBackground = SKEmitterNode(fileNamed: "StarsBackground") {
            
            starsBackground.position = CGPoint(x: 0, y: self.frame.maxY + 50)
            
            starsBackground.zPosition = -1
            
            starsBackground.advanceSimulationTime(50)
            
            self.addChild(starsBackground)
        }
        self.backgroundColor = UIColor(rgb: 0x242548)
    }
}
