//
//  CannonNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 15/02/22.
//

import SpriteKit

class CannonNode: SKNode {
    
    var cannonChargeIndicator = SKSpriteNode(imageNamed: "cannonEnergyCharge0")
    var cannonEnergy: Int = 0

    override init() {
        super.init()
        
        cannonChargeIndicator.size = CGSize(width: 50, height: 50)
        cannonChargeIndicator.zPosition = 50
        cannonChargeIndicator.makeShapeGlow(cornerRadius: 50, scaleSizeBy: 0.67, color: UIColor(named: "yellowMet"))
        guard let glow = cannonChargeIndicator.childNode(withName: "glow") as? SKShapeNode else {return}
        let glowing = SKAction.fadeAlpha(to: 0.6, duration: 1)
        let glowing2 = SKAction.fadeAlpha(to: 0.4, duration: 1)
        let glowSeq = SKAction.sequence([glowing, glowing2])
        glow.run(SKAction.repeatForever(glowSeq))
    }
    
    func cannonCharge() {
        if self.cannonEnergy == 3 {
            self.cannonEnergy = 0
        } else {
            self.cannonEnergy += 1
        }
        animateCharge(energy: cannonEnergy)
    }
    
    func shot() {
        guard let scene = scene,
        let shield = scene.childNode(withName: "shield") as? ShieldNode else {return}
        let cannonBullet = SKSpriteNode(imageNamed: "cannonShotYellow")
        
//        let crop = SKCropNode()
//        let rect = CGRect(origin: CGPoint(x:scene.frame.minX, y: scene.frame.minY), size: CGSize(width: scene.size.width, height: (scene.size.height / 2) + shield.frame.midY))
//        let mask = SKShapeNode(rect: rect)
////        SKShapeNode(circleOfRadius: abs(shield.frame.midY))
//        mask.lineWidth = scene.size.height
//        mask.position = CGPoint(x:scene.frame.midX, y: scene.frame.minY)
//        mask.zPosition = 50
//        crop.maskNode = mask
//        crop.zPosition = 10
//        crop.name = "crop"
        
        cannonBullet.name = "cannonBullet"
        cannonBullet.zPosition = 9
        cannonBullet.zRotation = shield.zRotation
        
        cannonBullet.size = CGSize(width: shield.frame.width / 2.5, height: shield.frame.width / 2)
        cannonBullet.position = CGPoint(x: (shield.frame.midX), y: (shield.frame.midY))
        
        cannonBullet.physicsBody = SKPhysicsBody(texture: cannonBullet.texture!, size: cannonBullet.size)
        cannonBullet.physicsBody?.usesPreciseCollisionDetection = true
        cannonBullet.physicsBody?.categoryBitMask = CollisionType.cannonBullet.rawValue
        cannonBullet.physicsBody?.collisionBitMask = 0
        cannonBullet.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue
        cannonBullet.physicsBody?.mass = 0.01
        
        cannonBullet.makeShapeGlow(cornerRadius: 10, scaleSizeBy: 1, color: .systemYellow)
        
        
//        scene.addChild(crop)

        scene.addChild(cannonBullet)

//        let scaleY = SKAction.scaleX(by: 1, y: 80, duration: 0.7)
//        let fade = SKAction.fadeOut(withDuration: 0.1)
//
//        let seq = [scaleY]
        
//        cannonBullet.run(scaleY) {
//            cannonBullet.removeFromParent()
//            crop.removeFromParent()
//        }
//        let completeSeq = [scaleY, fade, closeAndRemove]

        let speed : CGFloat = 20
        let adjustedAngle = shield.zRotation + CGFloat.pi / 2
        let dx = -(speed * cos(adjustedAngle))
        let dy = -(speed * sin(adjustedAngle))
        let act = SKAction.applyImpulse(CGVector(dx: dx, dy: dy), duration: 1)
        cannonBullet.run(act)
    }
    
//    func removeAndpoint() {
//        guard let scene = self.scene,
//        let enemy = scene.childNode(withName: "enemy") as? EnemyNode else {return}
//        let act = SKAction.run {
//            scene.childNode(withName: "crop")?.removeFromParent()
//        }
//        self.run(act){
////            enemy.life -= 1
//        }
//    }
    
    func animateCharge(energy: Int) {
        //FADE IN NEW ENERGY
        let newTexture = SKTexture(imageNamed: "cannonEnergyCharge\(cannonEnergy)")
        let dumbPlayerCopy = SKSpriteNode(imageNamed: "cannonEnergyCharge\(cannonEnergy)")
        dumbPlayerCopy.size = self.cannonChargeIndicator.size
        dumbPlayerCopy.zPosition = self.cannonChargeIndicator.zPosition + 1
        dumbPlayerCopy.alpha = 0
        cannonChargeIndicator.addChild(dumbPlayerCopy)

        let fadeIn = SKAction.fadeIn(withDuration: 0.5)

        dumbPlayerCopy.run(fadeIn) {
            self.cannonChargeIndicator.texture = newTexture
            dumbPlayerCopy.removeFromParent()
        }
        
        //SCALE ANIMATION
        let scale = SKAction.scale(by: 1.2, duration: 0.3)
        let scaleSequence = SKAction.sequence([scale, scale.reversed()])
        
        if cannonEnergy == 3 {
            cannonChargeIndicator.run(SKAction.repeat(scaleSequence, count: 2)){
                self.cannonChargeIndicator.run(SKAction.repeatForever(scaleSequence))
            }
        } else if cannonEnergy == 0 {
            cannonChargeIndicator.removeAllActions()
            cannonChargeIndicator.setScale(1)
        } else {
            cannonChargeIndicator.run(SKAction.repeat(scaleSequence, count: 2))
        }
        
        //SHADOW GLOW ANIMATION
        cannonChargeIndicator.animateShadowGlow(withName: "glow")
        if cannonEnergy == 3 {
            cannonChargeIndicator.animateShadowGlow(withName: "glow")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
