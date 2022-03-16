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
    var life: Int = 1
    let randomDouble : [Double] = [4.0, 5.0, 6.0, 7.0, 8.0]
    
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
        
        makeEnemyShadow()
//        guard let shadow = self.childNode(withName: "shadow") as? SKSpriteNode else {return}
//        shadow.run(SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.2))
//        shadow.run(SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.2))
        
        self.constraints = [SKConstraint.orient(to: .zero, offset: .init(constantValue: 0))]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire(enemyShootSound: SKAction, shouldPlaySound: Bool) {
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
        if shouldPlaySound {
            self.run(enemyShootSound)
        }
        scene?.addChild(weapon)
        weapon.makeShapeGlow(cornerRadius: 10, scaleSizeBy: 0.7, color: .systemPink)
        weapon.run(actionMove)

//        weapon.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
    }
    
    func startEndlessFiring(enemyShootSound: SKAction, shouldPlaySound: Bool){
        let shot = SKAction.run {
            self.fire(enemyShootSound: enemyShootSound, shouldPlaySound: shouldPlaySound)
        }
        let colorizeSeq = SKAction.sequence([SKAction.colorize(with: .magenta, colorBlendFactor: 0.5, duration: 0.17), SKAction.colorize(with: .clear, colorBlendFactor: 0, duration: 0.17)])
        let seq = SKAction.sequence([SKAction.wait(forDuration: 6, withRange: 4), colorizeSeq, colorizeSeq, shot])
        let endlessFiring = SKAction.repeatForever(seq)
        self.run(endlessFiring)
    }

    func configureMovement(sceneSize: CGSize) {
        let bezierPath1 = UIBezierPath(arcCenter: CGPoint(x: 0, y: -(sceneSize.height / 5)), radius: sceneSize.height / 5, startAngle: 0.0, endAngle: CGFloat.pi, clockwise: false)
        let bezierPath2 = UIBezierPath(arcCenter: CGPoint(x: 0, y: -(sceneSize.height / 5)), radius: sceneSize.height / 5, startAngle: CGFloat.pi, endAngle: 0.0, clockwise: true)
        
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
    
    func reduceLife() {
        self.life -= 1
        if life != 0 {
        animateHit(enemyLife: life)
        }
    }
    
    func animateHit(enemyLife: Int) {
        let newTexture = SKTexture(imageNamed: "enemy-\(enemyLife)")
        let dumbEnemyCopy = SKSpriteNode(imageNamed: "enemy-\(enemyLife)")
        dumbEnemyCopy.size = self.size
        dumbEnemyCopy.zPosition = zPosition + 1
        dumbEnemyCopy.alpha = 0
        
//        let scale = SKAction.scale(by: 0.9, duration: 0.3)
//        let scaleSequence = SKAction.sequence([scale, scale.reversed()])
//        self.run(SKAction.repeat(scaleSequence, count: 3))
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.27)
        let seq = SKAction.sequence([fadeIn, fadeIn.reversed()])
        
        dumbEnemyCopy.run(SKAction.repeat(seq, count: 4)) {
            self.texture = newTexture
            dumbEnemyCopy.removeFromParent()
        }
        addChild(dumbEnemyCopy)
//        self.animateShadowGlow(withName: "shadow")
        
        guard let shadow = self.childNode(withName: "shadow") as? SKSpriteNode else {return}
        shadow.run(SKAction.colorize(with: self.life == 2 ? .purple : .red, colorBlendFactor: 1, duration: 0.2))
    }
    
    func enemyBoom() {
       
            let frames = makeAnimationFrames(from: "enemyExplosion")
            let animHit = SKAction.animate(with: frames, timePerFrame: 0.026, resize: false, restore: false)
            
        self.run(animHit) {
            self.removeFromParent()
        }
    }
    
    func shouldFire(currentTime: TimeInterval) -> Bool {
        let randomNum = Double.random(in: 4...8)
        print(randomNum)
        if self.lastFiredTime + randomNum <= currentTime {
            return true
        } else {
            return false
        }
    }
}
