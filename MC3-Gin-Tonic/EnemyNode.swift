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
        
        makeTextureShadow(blurRadius: 7, xScaleFactor: 1.5, yScaleFactor: 1.3, color: .white)
        guard let shadow = self.childNode(withName: "shadow") as? SKSpriteNode else {return}
        shadow.run(SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.2))
        shadow.run(SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.2))
        
        self.constraints = [SKConstraint.orient(to: .zero, offset: .init(constantValue: 0))]
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
        weapon.physicsBody?.collisionBitMask = 0
        weapon.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.shield.rawValue | CollisionType.cannonBullet.rawValue
        
        weapon.physicsBody?.mass = 10
        
        let offset = aim - position
        let direction = offset.normalized()
        let shootAmount = direction * 2000
        let realDest = shootAmount + position
        
//        let speed: CGFloat = 1
//        let adjustedRotation = zRotation + (CGFloat.pi / 2)
        let actionMove = SKAction.move(to: realDest, duration: 6.5)
//        let dx = speed * cos(adjustedRotation)
//        let dy = speed * sin(adjustedRotation)
        scene?.addChild(weapon)
        weapon.run(actionMove)

//        weapon.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
    }

    func configureMovement(sceneSize: CGSize) {
        let bezierPath1 = UIBezierPath(arcCenter: CGPoint(x: 0, y: -(sceneSize.height / 4.4)), radius: sceneSize.height / 4.4, startAngle: 0.0, endAngle: CGFloat.pi, clockwise: false)
        let bezierPath2 = UIBezierPath(arcCenter: CGPoint(x: 0, y: -(sceneSize.height / 4.4)), radius: sceneSize.height / 4.4, startAngle: CGFloat.pi, endAngle: 0.0, clockwise: true)
        
        //        let pathNode1 = SKShapeNode(path: bezierPath1.cgPath)
        //        pathNode1.strokeColor = SKColor.blue
        //        pathNode1.lineWidth = 0
        ////        pathNode1.position = enemy.position
        //        addChild(pathNode1)
        //
        //        let pathNode2 = SKShapeNode(path: bezierPath2.cgPath)
        //        pathNode2.strokeColor = SKColor.red
        //        pathNode2.lineWidth = 0
        ////        pathNode2.position = enemy.position
        //        addChild(pathNode2)
        
        let followLine1 = SKAction.follow(bezierPath1.cgPath, asOffset: false, orientToPath: false, duration: 5)
        let followLine2 = SKAction.follow(bezierPath2.cgPath, asOffset: false, orientToPath: false, duration: 5)
        let finalLine = SKAction.sequence([followLine1, followLine2])
        let anotherAction = SKAction.repeatForever(finalLine)
        
        self.run(anotherAction)
    }
    
}
