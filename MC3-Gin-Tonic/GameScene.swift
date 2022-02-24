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
    case cannonBullet = 32
    case meteorite = 64
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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var player = PlayerNode(imageNamed: "playerShip-3")
    private var shield = ShieldNode(imageNamed: "shield")
    private var enemy = EnemyNode(imageNamed: "enemy")
    private var cannon = CannonNode()
    private var pause = PauseScreen()
    
    let playerShootSound = SKAction.playSoundFileNamed(SoundFile.playerShoot, waitForCompletion: false)
    let enemyShootSound = SKAction.playSoundFileNamed(SoundFile.enemyShoot, waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed(SoundFile.explosionSound, waitForCompletion: false)
    let cannonSound = SKAction.playSoundFileNamed(SoundFile.cannonSound, waitForCompletion: false)
    let powerUpSound = SKAction.playSoundFileNamed(SoundFile.powerUpSound, waitForCompletion: false)
    //    let wonSound = SKAction.playSoundFileNamed(SoundFile.wonSound, waitForCompletion: false)
    
    
    var isPlayerAlive = true
    var meteoriteLastSpawnTime: Double = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        makeBackground()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        
        let pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.size = CGSize(width: 30, height: 30)
        // Name the start node for touch detection:
        pauseButton.name = "PauseBtn"
        pauseButton.zPosition = 20
        pauseButton.position = CGPoint(x: frame.maxX - 35, y: frame.maxY - 55)
        
        addChild(pauseButton)
        //        self.addChild(pause)
        
        self.addChild(enemy)
        self.addChild(player)
        shield.position = CGPoint(x: player.frame.midX, y: player.frame.minY - shield.size.height * 0.5)
        self.addChild(shield)
        let join = SKPhysicsJointFixed.joint(withBodyA: player.physicsBody!, bodyB: shield.physicsBody!, anchor: CGPoint(x: player.frame.midX, y: player.frame.minY))
        self.physicsWorld.add(join)
        self.addChild(cannon)
        cannon.cannonChargeIndicator.position = CGPoint(x: frame.minX + 45, y: frame.maxY - 55)
        self.addChild(cannon.cannonChargeIndicator)
        
        let bezierPath1 = UIBezierPath(arcCenter: CGPoint(x: 0, y: -(self.size.height / 4.4)), radius: self.size.height / 4.4, startAngle: 0.0, endAngle: CGFloat.pi, clockwise: false)
        let bezierPath2 = UIBezierPath(arcCenter: CGPoint(x: 0, y: -(self.size.height / 4.4)), radius: self.size.height / 4.4, startAngle: CGFloat.pi, endAngle: 0.0, clockwise: true)
        
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
        
        enemy.run(anotherAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        
        let touchLocation = touch.location(in: self) //will be calculated already as a delta x and y from the center, since the anchor for self is the center, so will be -100x or 100 x and same the y
        
        if touchLocation.y < -20 {
            player.rotateControl(touchLocation: touchLocation, gestureType: .tapped)
        }
        
        let nodeTouched = atPoint(touchLocation)
        if nodeTouched.name == "PauseBtn" {
            if !self.isPaused {
                self.isPaused = true
                pause.zPosition = 30
                self.addChild(pause)
                
                //            if let view = self.view {
                //                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                ////                let pauseScreen = PauseScreen(size: self.size)
                ////
                ////                view.presentScene(pauseScreen, transition: reveal)
                //
                //            }
            }
        } else if nodeTouched.name == "ResumeBtn" {
            self.isPaused = false
            pause.removeFromParent()
        } else if nodeTouched.name == "QuitBtn" {
            if let view = self.view {
                let reveal = SKTransition.fade(withDuration: 0.5)
                let menuScene = MenuScreen(size: self.size)
                
                view.presentScene(menuScene, transition: reveal)
                
            }
        } else if nodeTouched.name == "SettingsBtn" {
            if let view = self.view {
                let reveal = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                
                view.presentScene(gameScene, transition: reveal)
                
            }
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
        
        if cannon.cannonEnergy == 3 {
            shield.openAndCloseAnimationRun()
            run(cannonSound)
            cannon.run(SKAction.wait(forDuration: 0.15)){
                self.cannon.shot()
            }
            cannon.cannonCharge()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        enemy.zRotation = (atan2(enemy.position.y, enemy.position.x) + CGFloat.pi)
        if player.isFiring {
            if player.lastFiredTime + 0.6 <= currentTime {
                player.lastFiredTime = currentTime
                player.fire()
                run(playerShootSound)
                //                run(playerShootAction)
            }
        }
        if enemy.lastFiredTime + Double(Int.random(in: 5...7)) <= currentTime {
            enemy.lastFiredTime = currentTime
            enemy.fire()
            run(enemyShootSound)
            //            run(enemyShootAction)
        }
        if meteoriteLastSpawnTime + 6 <= currentTime {
            meteoriteLastSpawnTime = currentTime
            let meteor = MeteoriteNode(minX: -scene!.frame.maxX, maxY: scene!.frame.maxY - scene!.view!.safeAreaInsets.top)
            addChild(meteor)
            meteor.startMoving()
        }
        
        for child in children {
            if child.name == "playerBullet" || child.name == "cannonBullet" {
                if child.frame.minY > frame.maxY * 1.1 || abs(child.frame.minX) > abs(frame.maxX * 1.1) {
                    child.removeFromParent()
                    
                }
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        let sortedNodes = [nodeA, nodeB].sorted {$0.name ?? "" < $1.name ?? ""}
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        /*
         possibilities:
         enemyWeapon - player
         enemyWeapon - shield
         cannonBullet - enemy
         meteor - playerBullet
         */
        
        if firstNode.name == "enemyWeapon" {
            firstNode.removeFromParent()
            if secondNode.name == "player" {
                makeExplosion(position: contact.contactPoint, on: player)
                player.reduceLife()
                
                if player.life == 0 {
                    //                    let lossSound = SKAction.playSoundFileNamed("loss.caf", waitForCompletion: false)
                    //                    run(lossSound)
                    run(SKAction.playSoundFileNamed(SoundFile.lossSound, waitForCompletion: true))
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameOverScene = GameOverScene(size: self.size, won: false)
                    //                    run(lossSound)
                    view?.presentScene(gameOverScene, transition: reveal)
                    
                }
            } else {
                shield.animateHit()
            }
        }
        
        if firstNode.name == "meteorite" {
            secondNode.removeFromParent()
            guard let meteor = firstNode as? MeteoriteNode else {return}
            if meteor.isDestroyedAfterHit() {
                run(powerUpSound)
                if cannon.cannonEnergy != 3 {
                    cannon.cannonCharge()
                    
                }
            }
        }
        
        if firstNode.name == "cannonBullet" {
            if secondNode.name == "enemy" {
                makeExplosion(position: contact.contactPoint, on: enemy)
                
                firstNode.removeFromParent()
                enemy.life -= 1
                
                if enemy.life == 0 {
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameOverScene = GameOverScene(size: self.size, won: true)
                    
                    view?.presentScene(gameOverScene, transition: reveal)
                    //                    print("YOU WON")
                    enemy.life = 3
                    
                }
            } else {
                if secondNode.name == "enemyWeapon" {
                    secondNode.removeFromParent()
                }
            }
        }
    }
    
    func makeExplosion(position: CGPoint, on parent: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "Explosion") {
            if parent.name == "enemy" {
                //                explosion.particleColor = .cyan
            }
            explosion.position = position
            self.addChild(explosion)
            run(explosionSound)
            //            run(explosionSoundAction)
            explosion.move(toParent: parent)
            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
            explosion.run(removeAfterDead)
        }
    }
    
    //    func makeBackground() {
    //        if let starsBackground = SKEmitterNode(fileNamed: "StarsBackground") {
    //            starsBackground.position = CGPoint(x: 0, y: self.frame.maxY + 50)
    //            starsBackground.zPosition = -1
    //            starsBackground.advanceSimulationTime(50)
    //            self.addChild(starsBackground)
    //        }
    //    }
}

