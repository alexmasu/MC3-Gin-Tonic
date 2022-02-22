//
//  CannonNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 15/02/22.
//

import SpriteKit

class CannonNode: SKNode {
    
    var cannonChargeIndicator : SKSpriteNode
    var cannonEnergy: Int = 3
    override init() {
        self.cannonChargeIndicator = SKSpriteNode(imageNamed: "charge0")
        super.init()
        self.cannonChargeIndicator.zPosition = 5
    }
    
    func cannonCharge() {
        if self.cannonEnergy == 3 {
//            self.cannonEnergy = 0
        } else {
            self.cannonEnergy += 1
        }
        self.cannonChargeIndicator.texture = SKTexture(imageNamed: "charge\(cannonEnergy)")
    }
    
    func shot() {
        guard let scene = scene,
        let shield = scene.childNode(withName: "shield") as? ShieldNode else {return}
        let cannonBullet = SKSpriteNode(imageNamed: "cannonBullet")
        
        let crop = SKCropNode()
        let rect = CGRect(origin: CGPoint(x:scene.frame.minX, y: scene.frame.minY), size: CGSize(width: scene.size.width, height: (scene.size.height / 2) + shield.frame.midY))
        let mask = SKShapeNode(rect: rect)
//        SKShapeNode(circleOfRadius: abs(shield.frame.midY))
        mask.lineWidth = scene.size.height
        mask.position = CGPoint(x:scene.frame.midX, y: scene.frame.minY)
        mask.zPosition = 50
        crop.maskNode = mask
        crop.zPosition = 10
        
        cannonBullet.name = "cannonBullet"
        cannonBullet.zPosition = -1
        cannonBullet.zRotation = shield.zRotation
        
        cannonBullet.size = CGSize(width: shield.frame.width / 1.5, height: shield.frame.height / 1.5)
        cannonBullet.position = CGPoint(x: (shield.frame.midX), y: (shield.frame.midY))
        
        cannonBullet.physicsBody = SKPhysicsBody(rectangleOf: cannonBullet.size)
        cannonBullet.physicsBody?.usesPreciseCollisionDetection = true
        cannonBullet.physicsBody?.categoryBitMask = CollisionType.cannonBullet.rawValue
        cannonBullet.physicsBody?.collisionBitMask = 0
        cannonBullet.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue
        
        let scaleY = SKAction.scaleX(by: 1, y: 100, duration: 0.5)
        let fade = SKAction.fadeOut(withDuration: 0.1)
        let seq = [scaleY, fade]
        
//        let speed : CGFloat = 20
//        let adjustedAngle = shield.zRotation + CGFloat.pi / 2
//        let dx = -(speed * cos(adjustedAngle))
//        let dy = -(speed * sin(adjustedAngle))
//        let act = SKAction.applyImpulse(CGVector(dx: dx, dy: dy), duration: 1)
        
        shield.openCannonAnimationRun()
        cannonBullet.run(SKAction.sequence(seq)){
            shield.closeCannonAnimationRun()
            cannonBullet.removeFromParent()
        }
        scene.addChild(crop)

        crop.addChild(cannonBullet)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
