//
//  ShieldNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 11/02/22.
//

import SpriteKit

class ShieldNode: SKSpriteNode {
    let emitterShield = SKEmitterNode(fileNamed: "ShieldBackGlow")

    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .white, size: texture.size())

        self.size = CGSize(width: self.size.width / 1.5, height: self.size.height)
        name = "shield"
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        zPosition = 2
        physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        physicsBody?.categoryBitMask = CollisionType.shield.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = CollisionType.enemyWeapon.rawValue
        physicsBody?.isDynamic = true

        emitterShield?.particleSize = self.size
        emitterShield?.particleLifetime = self.size.width / 150
        emitterShield?.particleAlpha = 7
        emitterShield?.zPosition = 1
        emitterShield?.advanceSimulationTime(7)
        
        self.addChild(emitterShield!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
