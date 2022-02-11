//
//  GameScene.swift
//  MC3-Gin-Tonic
//
//  Created by Alessandro Masullo on 08/02/22.
//

import SpriteKit

enum CollisionType: UInt32 {
    case enemy = 1
    case enemyWeapon = 2
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}

class GameScene: SKScene {
    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
    
    let enemy = SKSpriteNode(imageNamed: "enemy")
    var enemyLastFireTime: Double = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        enemy.name = "enemy"
        enemy.position.y = frame.minY - 500
//        enemy.position = .init(x: 0, y: -800)
        enemy.zPosition = 1
        addChild(enemy)
        
//        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.texture!.size())
//        enemy.physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
//        enemy.physicsBody?.categoryBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
//        enemy.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        enemy.physicsBody?.isDynamic = false
//        enemy.anchorPoint = CGPoint(x: 0.5, y: 1)
       
        let bezierPath1 = UIBezierPath(arcCenter: CGPoint(x: 0, y: -300), radius: 300, startAngle: CGFloat(0), endAngle: CGFloat(M_PI), clockwise: false)
        let bezierPath2 = UIBezierPath(arcCenter: CGPoint(x: 0, y: -300), radius: 300, startAngle: CGFloat(180), endAngle: CGFloat(0), clockwise: true)
        
        let pathNode1 = SKShapeNode(path: bezierPath1.cgPath)
        pathNode1.strokeColor = SKColor.blue
        pathNode1.lineWidth = 0
//        pathNode1.position = enemy.position
        addChild(pathNode1)
        
        let pathNode2 = SKShapeNode(path: bezierPath2.cgPath)
        pathNode2.strokeColor = SKColor.red
        pathNode2.lineWidth = 0
//        pathNode2.position = enemy.position
        addChild(pathNode2)
        
        
        
        let followLine1 = SKAction.follow(bezierPath1.cgPath, asOffset: false, orientToPath: true, duration: 5)
//        let reversedLine = followLine.reversed()
        let finalLine = SKAction.sequence([.run { self.enemy.xScale = 1
            self.enemy.yScale = 1
        }, followLine1, .run { self.enemy.yScale = -1
            self.enemy.xScale = -1
        }, followLine1.reversed()])
        let anotherAction = SKAction.repeatForever(finalLine)

      
                                         
        
        enemy.run(anotherAction)
    }
    
    func fire() {
        let aim = CGPoint(x: frame.midX, y: frame.midY)
        let weaponType = "enemyWeapon"
        let weapon = SKSpriteNode(imageNamed: weaponType)
        weapon.name = "enemyWeapon"
        weapon.position = enemy.position
        weapon.zRotation = enemy.zRotation
        let offset = aim - weapon.position
        addChild(weapon)
        let direction = offset.normalized()
        let shootAmount = direction * 2000
        let realDest = shootAmount + weapon.position
        
        
        weapon.physicsBody = SKPhysicsBody(rectangleOf: weapon.size)
        weapon.physicsBody?.categoryBitMask = CollisionType.enemyWeapon.rawValue
//        weapon.physicsBody?.collisionBitMask = CollisionType.player.rawValue
//        weapon.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        weapon.physicsBody?.mass = 0.001
        
        let speed: CGFloat = 1
        let adjustedRotation = zRotation + (CGFloat.pi / 2)
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        
        let dx = speed * cos(adjustedRotation)
        let dy = speed * sin(adjustedRotation)
        weapon.run(actionMove)
//        weapon.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
    }
    override func update(_ currentTime: TimeInterval) {
        if enemyLastFireTime + 0.8 <= currentTime {
            enemyLastFireTime = currentTime
            self.fire()
        }
        
    }
}
