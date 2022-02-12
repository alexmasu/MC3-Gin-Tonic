//
//  PlayerNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 11/02/22.
//

import SpriteKit

class PlayerNode: SKSpriteNode {
    
    var lastFiredTime: Double = 0
    var isFiring = false
    var shield = ShieldNode(imageNamed: "shield")
    
    init(imageNamed: String) {
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "player"
        position = CGPoint(x: 0, y: 0)
        zPosition = 2
        
        physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        physicsBody?.categoryBitMask = CollisionType.player.rawValue
        physicsBody?.collisionBitMask = CollisionType.enemyWeapon.rawValue
        physicsBody?.contactTestBitMask = CollisionType.enemyWeapon.rawValue
        physicsBody?.isDynamic = false

        shield.position = CGPoint(x: self.frame.midX, y: self.frame.minY - shield.size.height * 0.5)
        self.addChild(shield)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum ControlType {
        case tapped, moved
    }
    
    func rotateControl(touchLocation: CGPoint, gestureType: ControlType) {
        
        let angle = atan2(touchLocation.x, touchLocation.y)
        //conversions: degreesToRadians = CGFloat.pi / 180 | radiansToDegrees = 180 / CGFloat.pi
        let playerAngle = -(angle + CGFloat.pi)
        
        switch gestureType {
        case .tapped:
            let rotation = SKAction.rotate(toAngle: playerAngle, duration: 0.12, shortestUnitArc: true)
            self.run(rotation) {
                self.isFiring = true
            }
        case .moved:
            let rotation = SKAction.rotate(toAngle: playerAngle, duration: 0.099, shortestUnitArc: true)
            self.run(rotation)
            self.isFiring = true
        }
    }
    
    func fire() {
        let playerBullet = SKSpriteNode(imageNamed: "playerBullet")
        playerBullet.name = "playerBullet"
        
        let playerAngleAdjusted = self.zRotation + CGFloat.pi / 2
        //Bullet angle adjusted
        let adjustedAngle = playerAngleAdjusted + CGFloat.pi / 2
        
        playerBullet.anchorPoint = CGPoint(x: 0.5, y: 0)
        playerBullet.size = CGSize(width: playerBullet.size.width, height: playerBullet.size.height)
        
        playerBullet.position = CGPoint(x: ((self.size.width / 2) * cos(playerAngleAdjusted)), y: ((self.size.width / 2) * sin(playerAngleAdjusted)))
        playerBullet.zPosition = 2
        playerBullet.zRotation = adjustedAngle
        
        playerBullet.physicsBody = SKPhysicsBody(texture: playerBullet.texture!, size: playerBullet.size)
        playerBullet.physicsBody?.categoryBitMask = CollisionType.playerBullet.rawValue
        playerBullet.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue
        playerBullet.physicsBody?.contactTestBitMask = CollisionType.enemyWeapon.rawValue
        
        playerBullet.physicsBody?.mass = 0.02
        let speed: CGFloat = 10
        
        self.parent!.addChild(playerBullet)

        let dx = speed * cos(playerAngleAdjusted)
        let dy = speed * sin(playerAngleAdjusted)
        playerBullet.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
                
        let scale = SKAction.scale(by: 1.06, duration: 0.07)
        let scaleSequence = SKAction.sequence([scale, scale.reversed()])
        
        self.run(scaleSequence)
    }
    
    func stopFire(touchesCount: Int) {
        if touchesCount == 1 {
            self.run(SKAction.wait(forDuration: 0.121)) {
                self.isFiring = false
            }
        } else {
            self.isFiring = false
        }
    }

}
