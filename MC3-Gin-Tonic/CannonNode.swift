//
//  CannonNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 15/02/22.
//

import SpriteKit

class CannonNode: SKNode {
    
    var cannonChargeIndicator : SKSpriteNode
    var cannonEnergy: Int = 0
    
    override init() {
        self.cannonChargeIndicator = SKSpriteNode(imageNamed: "charge0")
        super.init()
        self.cannonChargeIndicator.zPosition = 5
    }
    
    func cannonCharge() {
        if self.cannonEnergy == 3 {
            self.cannonEnergy = 0
        } else {
            self.cannonEnergy += 1
        }
        self.cannonChargeIndicator.texture = SKTexture(imageNamed: "charge\(cannonEnergy)")
    }
    
    func shot() {
        let cannonBullet = SKSpriteNode(imageNamed: "cannonBullet")
        guard let shield = scene?.childNode(withName: "shield") else {return}
        
//        let mask = SKShapeNode(circleOfRadius: self.frame.midY / cos(self.zRotation))
//        mask.zPosition = 10
//        mask.fillColor = .blue
//        parent?.addChild(mask)
        
        cannonBullet.name = "cannonBullet"
        cannonBullet.zPosition = 1
        cannonBullet.zRotation = shield.zRotation
        
        cannonBullet.size = CGSize(width: cannonBullet.size.width / 1.5, height: cannonBullet.size.height / 1.5)
        cannonBullet.position = CGPoint(x: (shield.frame.midX), y: (shield.frame.midY))
        
        let adjustedAngle = shield.zRotation + CGFloat.pi / 2
        
        cannonBullet.physicsBody = SKPhysicsBody(texture: cannonBullet.texture!, size: cannonBullet.size)
        cannonBullet.physicsBody?.usesPreciseCollisionDetection = true
        cannonBullet.physicsBody?.categoryBitMask = CollisionType.cannonBullet.rawValue
        cannonBullet.physicsBody?.collisionBitMask = 0
        cannonBullet.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue
        
        cannonBullet.physicsBody?.mass = 0.02
        let speed : CGFloat = 14
        
        scene!.addChild(cannonBullet)
        
        let dx = -(speed * cos(adjustedAngle))
        let dy = -(speed * sin(adjustedAngle))
        cannonBullet.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
