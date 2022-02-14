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
    case player = 4
    case shield = 8
    case playerBullet = 16
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
    
    private var player = PlayerNode(imageNamed: "playerShip")
    private var shield = ShieldNode(imageNamed: "shield")
    
    let enemy = SKSpriteNode(imageNamed: "enemy")
    var enemyLastFireTime: Double = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        
        self.addChild(player)
        shield.position = CGPoint(x: player.frame.midX, y: player.frame.minY - shield.size.height * 0.5)
        self.addChild(shield)
        let join = SKPhysicsJointFixed.joint(withBodyA: player.physicsBody!, bodyB: shield.physicsBody!, anchor: CGPoint(x: player.frame.midX, y: player.frame.minY))
        self.physicsWorld.add(join)
        
        enemy.name = "enemy"
        enemy.position.y = frame.minY
//        enemy.position = .init(x: 0, y: -800)
        enemy.zPosition = 1
        addChild(enemy)
        
//        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.texture!.size())
//        enemy.physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
//        enemy.physicsBody?.categoryBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
//        enemy.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        enemy.physicsBody?.isDynamic = false
//        enemy.anchorPoint = CGPoint(x: 0.5, y: 1)
       
        let bezierPath1 = UIBezierPath(arcCenter: CGPoint(x: 0, y: -(self.size.height / 4.4)), radius: self.size.height / 4.4, startAngle: 0.0, endAngle: CGFloat.pi, clockwise: false)
        let bezierPath2 = UIBezierPath(arcCenter: CGPoint(x: 0, y: -(self.size.height / 4.4)), radius: self.size.height / 4.4, startAngle: 180.0, endAngle: 0.0, clockwise: true)
        
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
        
        
        weapon.physicsBody = SKPhysicsBody(rectangleOf: weapon.size)
        weapon.physicsBody?.categoryBitMask = CollisionType.enemyWeapon.rawValue
        weapon.physicsBody?.collisionBitMask = CollisionType.shield.rawValue
        weapon.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        weapon.physicsBody?.mass = 10
        
        addChild(weapon)

        let offset = aim - weapon.position
        let direction = offset.normalized()
        let shootAmount = direction * 2000
        let realDest = shootAmount + weapon.position
        
//        let speed: CGFloat = 1
//        let adjustedRotation = zRotation + (CGFloat.pi / 2)
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        
//        let dx = speed * cos(adjustedRotation)
//        let dy = speed * sin(adjustedRotation)
        weapon.run(actionMove)
//        weapon.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
        /*
         If the enemy bullet follows a path at hight speed like here (instead of an impulse) it goes through the player, the contact is detected but the bullet continue the path. That's why if we add the collisions masks it seems like there's no collision, but if you run with a longer duration for the actionMove, like 10, you see that the contact it's happening
         */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: self) //will be calculated already as a delta x and y from the center, since the anchor for self is the center, so will be -100x or 100 x and same the y
        
        if touchLocation.y < -20 {
            player.rotateControl(touchLocation: touchLocation, gestureType: .tapped)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {return}
        var touchLocation = firstTouch.location(in: self)

        for touch in touches {
            touchLocation = touch.location(in: self)
            if touchLocation.y < -20 {
                player.rotateControl(touchLocation: touchLocation, gestureType: .moved)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFire(touchesCount: touches.count)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if player.isFiring {
            if player.lastFiredTime + 0.6 <= currentTime {
                player.lastFiredTime = currentTime
                player.fire()
            }
        }
        if enemyLastFireTime + 0.8 <= currentTime {
            enemyLastFireTime = currentTime
            self.fire()
        }
        
        for child in children {
            if child.name == "playerBullet" {
                if child.frame.minY > frame.maxY * 1.1 || abs(child.frame.minX) > abs(frame.maxX * 1.1) {
                    child.removeFromParent()
                }
            }
        }
    }
}
