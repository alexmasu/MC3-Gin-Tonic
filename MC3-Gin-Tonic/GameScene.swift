//
//  GameScene.swift
//  MC3-Gin-Tonic
//
//  Created by Alessandro Masullo on 08/02/22.
//

import SpriteKit
//import AVFoundation

enum CollisionType: UInt32 {
    case enemy = 1
    case enemyWeapon = 2
    case player = 4
    case shield = 8
    case playerBullet = 16
    case cannonBullet = 32
    case meteorite = 64
    case metParticles = 128
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
    private var enemy = EnemyNode(imageNamed: "enemy-3")
    private var cannon = CannonNode()
    private var pause = PauseScreen()
    private var metSpawner = MetSpawner()
    
    let effectsSouldPlay = UserDefaults.standard.bool(forKey: "effects")
    let musicSouldPlay = UserDefaults.standard.bool(forKey: "music")
    let notificationCenter = NotificationCenter.default
        
    let playerShootSound = SKAction.playSoundFileNamed(SoundFile.playerShoot, waitForCompletion: false)
    let enemyShootSound = SKAction.playSoundFileNamed(SoundFile.enemyShoot, waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed(SoundFile.explosionSound, waitForCompletion: false)
    let cannonSound = SKAction.playSoundFileNamed(SoundFile.cannonSound, waitForCompletion: false)
    let powerUpSound = SKAction.playSoundFileNamed(SoundFile.powerUpSound, waitForCompletion: false)
    let wonSound = SKAction.playSoundFileNamed(SoundFile.wonSound, waitForCompletion: true)
    
    var isPlayerAlive = true
    var enemyShouldFire = false
    var meteoritesShoulSpawn = false
        
    override func didMove(to view: SKView) {
        notificationCenter.addObserver(self, selector: #selector(pauseGame), name: UIApplication.didBecomeActiveNotification, object: nil)

        physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        makeBackground()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(player)
        shield.position = CGPoint(x: player.frame.midX, y: player.frame.minY - shield.size.height * 0.2)
        self.addChild(shield)
        if let speeed = SKEmitterNode(fileNamed: "SpeedParticles"){
            speeed.zPosition = 1
            self.addChild(speeed)
        }
        let join = SKPhysicsJointFixed.joint(withBodyA: player.physicsBody!, bodyB: shield.physicsBody!, anchor: CGPoint(x: player.frame.midX, y: player.frame.minY - shield.size.height * 0.5))
        self.physicsWorld.add(join)
        self.addChild(cannon)
        cannon.cannonChargeIndicator.position = CGPoint(x: frame.minX + cannon.cannonChargeIndicator.size.width * 1.1, y: frame.maxY - cannon.cannonChargeIndicator.size.width * 1.1)
        self.addChild(cannon.cannonChargeIndicator)
        
        let pauseButton = SKSpriteNode(imageNamed: "PauseIcon")
        pauseButton.size = CGSize(width: self.frame.width / 12 , height: self.frame.width / 12)
        // Name the start node for touch detection:
        pauseButton.name = "PauseBtn"
        pauseButton.zPosition = 20
        pauseButton.position = CGPoint(x: -cannon.cannonChargeIndicator.position.x, y: cannon.cannonChargeIndicator.position.y)
        
        addChild(pauseButton)
        //        self.addChild(pause)
        
        enemy.configureMovement(sceneSize: self.size)
        self.addChild(enemy)

        let wait = SKAction.wait(forDuration: Double.random(in: 5...7))
        self.run(wait){
            self.enemyShouldFire = true
        }
        let wait2 = SKAction.wait(forDuration: 2)
        self.run(wait2){
            self.meteoritesShoulSpawn = true
        }
        addChild(metSpawner)
        metSpawner.configurePossibleStartXandY()
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
            }
        } else if nodeTouched.name == "ResumeBtn" {
            pause.removeFromParent()
            self.isPaused = false
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
            if effectsSouldPlay {
                run(cannonSound)
            }
            cannon.run(SKAction.wait(forDuration: 0.15)){
                self.cannon.shot()
            }
            cannon.cannonCharge()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if player.isFiring {
            if player.lastFiredTime + 0.6 <= currentTime {
                player.lastFiredTime = currentTime
                player.fire()
                if effectsSouldPlay {
                    run(playerShootSound)
                }
            }
        }
        if enemy.lastFiredTime + Double(Int.random(in: 4...8)) <= currentTime {
            if enemyShouldFire {
                enemy.lastFiredTime = currentTime
                enemy.fire()
                if effectsSouldPlay {

                run(enemyShootSound)
                }
            }
        }
        if metSpawner.meteoriteLastSpawnTime + 6 <= currentTime {
            if meteoritesShoulSpawn {
                metSpawner.meteoriteLastSpawnTime = currentTime
                metSpawner.spawnAndStartMoving()
            }
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
         cannonBullet - enemyWeapon
         meteor - playerBullet
         metParticle - player
         */
        
        if firstNode.name == "enemyWeapon" {
            firstNode.removeFromParent()
            if secondNode.name == "player" {
                makeExplosion(position: contact.contactPoint, on: player)
                player.shake()
                player.reduceLife()
                
                if player.life == 0 {
                    if effectsSouldPlay {
                    run(SKAction.playSoundFileNamed(SoundFile.lossSound, waitForCompletion: true))
                    }
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameOverScene = GameOverScene(size: self.size, won: false)
                    self.run(SKAction.wait(forDuration: 0.4)){
                        self.view?.presentScene(gameOverScene, transition: reveal)
                    }
                }
            } else {
                shield.animateHit()
            }
        }
        
        if firstNode.name == "meteorite" {
            secondNode.removeFromParent()
            guard let meteor = firstNode as? MeteoriteNode else {return}
            if meteor.isDestroyedAfterHit() {
                if effectsSouldPlay {
                run(powerUpSound)
                }
            }
        }
        
        if firstNode.name == "cannonBullet" {
            if secondNode.name == "enemy" {
                makeExplosion(position: contact.contactPoint, on: enemy)
                
                firstNode.removeFromParent()
                enemy.run(SKAction.colorize(with: .black, colorBlendFactor: 0.9, duration: 0.15)){
                    self.enemy.run(SKAction.colorize(with: .clear, colorBlendFactor: 0, duration: 0.15))
                }
//                enemy.life -= 1
                enemy.reduceLife()
                if enemy.life == 0 {
                    run(wonSound) {
                        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                        let gameOverScene = GameOverScene(size: self.size, won: true)
                        
                        self.view?.presentScene(gameOverScene, transition: reveal)
                        self.enemy.life = 3
                    }
                }
            } else {
                if secondNode.name == "enemyWeapon" {
                    secondNode.removeFromParent()
                }
            }
        }
        if firstNode.name == "metParticles" {
            player.animateEnergyPick()
            if cannon.cannonEnergy != 3 {
                cannon.cannonCharge()
                if cannon.cannonEnergy == 3{
                    shield.scaleCannonCharged()
                }
            }
        }
    }
    
    func makeExplosion(position: CGPoint, on parent: SKSpriteNode) {
        let fileName = parent.name == "enemy" ? "ExplosionYellow" : "Explosion"
        if let explosion = SKEmitterNode(fileNamed: fileName) {
            explosion.position = position
            self.addChild(explosion)
            if effectsSouldPlay {
                run(explosionSound)
            }
            explosion.move(toParent: parent)
            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
            explosion.run(removeAfterDead)
        }
    }
    @objc func pauseGame(){
        print("game is paused!")
        self.isPaused = true
        pause.zPosition = 30
        if self.childNode(withName: "pauseScreen") == nil {
            self.addChild(pause)
        }
    }
}

