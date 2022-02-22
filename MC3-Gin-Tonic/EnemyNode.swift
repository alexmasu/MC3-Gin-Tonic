//
//  EnemyNode.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 10/02/22.
//

import SpriteKit

class EnemyNode: SKSpriteNode {
    
    var lastFiredTime: Double = 9
    var isFiring = true
//    var jointAnchor : CGPoint = .zero
    var life: Int = 3
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "enemy"
        position.y = frame.minY
        zPosition = 2
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
        physicsBody?.collisionBitMask = CollisionType.cannonBullet.rawValue
        
        physicsBody?.contactTestBitMask = CollisionType.cannonBullet.rawValue
        physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire() {
        let aim = CGPoint.zero
        let weaponType = "enemyWeapon"
        let weapon = SKSpriteNode(imageNamed: weaponType)
        weapon.name = "enemyWeapon"
        
        weapon.zPosition = 2
        weapon.zRotation = zRotation - CGFloat.pi / 2
        weapon.size = CGSize(width: self.size.height * 0.07, height: self.size.width * 0.15)
        weapon.position = position - position / 4

        weapon.physicsBody = SKPhysicsBody(rectangleOf: weapon.size)
        weapon.physicsBody?.usesPreciseCollisionDetection = true
        weapon.physicsBody?.categoryBitMask = CollisionType.enemyWeapon.rawValue
        weapon.physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.shield.rawValue
        weapon.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.shield.rawValue
        
        weapon.physicsBody?.mass = 10
        
        let offset = aim - position
        let direction = offset.normalized()
        let shootAmount = direction * 2000
        let realDest = shootAmount + position
        
//        let speed: CGFloat = 1
//        let adjustedRotation = zRotation + (CGFloat.pi / 2)
        let actionMove = SKAction.move(to: realDest, duration: 6.0)
//        let dx = speed * cos(adjustedRotation)
//        let dy = speed * sin(adjustedRotation)
        self.parent!.addChild(weapon)
        weapon.run(actionMove)

//        weapon.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
    }
}
