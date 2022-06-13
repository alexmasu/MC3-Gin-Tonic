//
//  GameScene.swift
//  MC3-Gin-Tonic
//
//  Created by Alessandro Masullo on 08/02/22.
//
import AVFoundation
import SpriteKit

enum CollisionType: UInt32 {
    case enemy = 1
    case enemyWeapon = 2
    case player = 4
    case shield = 8
    case playerBullet = 16
    case cannonBullet = 32
    case meteorite = 64
    case metParticles = 128
    case cannonChargeIndicator = 256
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
    private var pause = PauseScreen(music: UserDefaults.standard.bool(forKey: "music"), effects: UserDefaults.standard.bool(forKey: "effects"))
    private var metSpawner = MetSpawner()
    
    let notificationCenter = NotificationCenter.default
        
    let playerShootSound = SKAction.playSoundFileNamed(SoundFile.playerShoot, waitForCompletion: false)
    let enemyShootSound = SKAction.playSoundFileNamed(SoundFile.enemyShoot, waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed(SoundFile.explosionSound, waitForCompletion: false)
    let cannonSound = SKAction.playSoundFileNamed(SoundFile.cannonSound, waitForCompletion: false)
    let powerUpSound = SKAction.playSoundFileNamed(SoundFile.powerUpSound, waitForCompletion: false)
    let wonSound = SKAction.playSoundFileNamed(SoundFile.wonSound, waitForCompletion: true)
    let popButtons = SKAction.playSoundFileNamed(SoundFile.popButtons, waitForCompletion: true)
    
    var backgroundMusicAV : AVAudioPlayer!
    
    var music = UserDefaults.standard.bool(forKey: "music")
    var effects = UserDefaults.standard.bool(forKey: "effects")

    var enemyShouldFire = false
    var meteoritesShoulSpawn = false
    
    var score: Double = 0
    var scoreLabel2 = SKLabelNode(fontNamed: "AdventPro-Bold")

    override func didMove(to view: SKView) {
        notificationCenter.addObserver(self, selector: #selector(pauseGame), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        setUpBgMusic(fileName: "Ab1ss1 (online-audio-converter.com).mp3")
        
        if music {
            if !self.backgroundMusicAV.isPlaying {
              self.backgroundMusicAV.play()
            }
        }

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
        
        addPauseButton()
        enemy.configureMovement(sceneSize: self.size)
        self.addChild(enemy)

        let wait = SKAction.wait(forDuration: 5)
        self.run(wait){
            self.enemyShouldFire = true
            self.enemy.startEndlessFiring(enemyShootSound: self.enemyShootSound, shouldPlaySound: self.effects)
        }
        let wait2 = SKAction.wait(forDuration: 2)
        
        addChild(metSpawner)
        metSpawner.configurePossibleStartXandY()
        self.run(wait2){
            self.metSpawner.endlessSpawning()
        }
                
        scoreLabel2.verticalAlignmentMode = .top
        scoreLabel2.horizontalAlignmentMode = .center
        scoreLabel2.fontSize = self.size.height * 0.04
        scoreLabel2.fontColor = UIColor(named: "alienGreen")
        scoreLabel2.position = CGPoint(x: 0, y: self.frame.maxY - self.size.height * 0.05)
        scoreLabel2.addStroke()
        self.addChild(scoreLabel2)

        self.startCalculatingMeterScore()
        enemy.startIncreasingSpeed()
        metSpawner.startIncreasingSpeed()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        
        let touchLocation = touch.location(in: self) //will be calculated already as a delta x and y from the center, since the anchor for self is the center, so will be -100x or 100 x and same the y
        
        if touchLocation.y < -20 {
            player.rotateControl(touchLocation: touchLocation, gestureType: .tapped)
        }
        
        let nodeTouched = atPoint(touchLocation)
        
        if nodeTouched.name == "PauseBtn" {
            self.playTapSound(action: popButtons, shouldPlayEffects: effects)
            nodeTouched.removeFromParent()
                self.pauseChilds(isPaused: true)
                self.pause.zPosition = 30
                self.addChild(self.pause)
            
        } else if nodeTouched.name == "ResumeBtn" {
            self.playTapSound(action: popButtons, shouldPlayEffects: effects)
            pause.removeFromParent()
            addPauseButton()
            pauseChilds(isPaused: false)
            
        } else if nodeTouched.name == "QuitBtn" {
            
            if let view = self.view {
                self.playTapSound(action: popButtons, shouldPlayEffects: effects)
                backgroundMusicAV.stop()
                let reveal = SKTransition.fade(withDuration: 0.5)
                let menuScene = MenuScreen(size: self.size)
                
                view.presentScene(menuScene, transition: reveal)
                
            }
        } else if nodeTouched.name == "SettingsBtn" {
            if let view = self.view {
                self.playTapSound(action: popButtons, shouldPlayEffects: effects)
                backgroundMusicAV.stop()

                let reveal = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                
                view.presentScene(gameScene, transition: reveal)
            }
        }
        if nodeTouched.name == "musicButton" {
            self.playTapSound(action: popButtons, shouldPlayEffects: effects)
            music.toggle()
            UserDefaults.standard.set(music, forKey: "music")
            guard let musicEffectsButton = nodeTouched as? LittleCircleNode else {return}
            musicEffectsButton.changeTextureOnOff(onOff: music)
            if music == true {
                backgroundMusicAV.play()
            } else if music == false {
                backgroundMusicAV.stop()
            }
        }
        if nodeTouched.name == "specialEffectsButton" {
            self.playTapSound(action: popButtons, shouldPlayEffects: effects)
            effects.toggle()
            UserDefaults.standard.set(effects, forKey: "effects")
            guard let specialEffectsButton = nodeTouched as? LittleCircleNode else {return}
                specialEffectsButton.changeTextureOnOff(onOff: effects)
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
            if effects {
                run(cannonSound)
            }
            cannon.run(SKAction.wait(forDuration: 0.15)){
                self.cannon.shot()
            }
            cannon.cannonCharge()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        scoreLabel2.text = String(format: "%.2f", score)

        if player.isFiring && player.isPaused == false {
            if player.lastFiredTime + 0.6 - (player.fakeNode.speed*0.02) <= currentTime {
                player.lastFiredTime = currentTime
                player.fire()
                if effects {
                    run(playerShootSound)
                }
            }
        }
//        if enemy.shouldFire(currentTime: currentTime) {
//            if enemyShouldFire && enemy.isPaused == false {
//                enemy.lastFiredTime = currentTime
//                enemy.run(SKAction.wait(forDuration: Double.random(in: 0...4))){
//                    self.enemy.fire()
//                    if self.effects {
//                            self.run(self.enemyShootSound)
//    //                    }
//                    }
//                }
////                let seq = SKAction.sequence([SKAction.colorize(with: .magenta, colorBlendFactor: 0.5, duration: 0.15), SKAction.colorize(with: .clear, colorBlendFactor: 0, duration: 0.15)])
////                enemy.run(SKAction.repeat(seq, count: 2)){
//                print(currentTime)
//            }
//        }
//        if metSpawner.meteoriteLastSpawnTime + 6 <= currentTime {
//            if meteoritesShoulSpawn {
//                metSpawner.meteoriteLastSpawnTime = currentTime
//                metSpawner.spawnAndStartMoving()
//            }
//        }
        
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
                    if effects {
                    run(SKAction.playSoundFileNamed(SoundFile.lossSound, waitForCompletion: true))
                    }
                    backgroundMusicAV.stop()

                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameScoreScene = GameOverScoreScene(size: self.size, score: score, playerLife: player.life)
                    self.run(SKAction.wait(forDuration: 0.4)){
                        self.view?.presentScene(gameScoreScene, transition: reveal)
                    }
                }
            } else {
                shield.animateHit()
            }
        }
        
        if firstNode.name == "meteorite" {
            secondNode.removeFromParent()
            guard let meteor = firstNode as? MeteoriteNode else {return}
            if meteor.life == 2{
                score += 2
            } else if meteor.life == 1 {
                score += 4
            }
            if meteor.isDestroyedAfterHit() {
                score += 6
            }
        }
        
        if firstNode.name == "cannonBullet" {
            if secondNode.name == "enemy" {
                makeExplosion(position: contact.contactPoint, on: enemy)
                self.score += 20
                
                firstNode.removeFromParent()
                enemy.run(SKAction.colorize(with: .black, colorBlendFactor: 0.9, duration: 0.12)){
                    self.enemy.run(SKAction.colorize(with: .clear, colorBlendFactor: 0, duration: 0.12))
                }
//                enemy.reduceLife()
//                if enemy.life == 0 {
//                    enemy.enemyBoom()
//                    if effects {
//                        run(wonSound)
//                    }
//
//                    self.run(SKAction.wait(forDuration: 0.8)) {
//                        self.backgroundMusicAV.stop()
////                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
////                        let gameOverScene = GameOverScene(size: self.size, won: true, playerLife: self.player.life)
//
////                        self.view?.presentScene(gameOverScene, transition: reveal)
//                        self.enemy.life = 3
//                    }
//                }
            } else {
                if secondNode.name == "enemyWeapon" {
                    secondNode.removeFromParent()
                }
            }
        }
        if firstNode.name == "cannonChargeIndicator" {
            if cannon.cannonEnergy != 3 {
                if effects {
                    run(powerUpSound)
                }
                cannon.cannonCharge()
                if cannon.cannonEnergy == 3{
                    shield.scaleCannonCharged()
                }
            }
        }
    }
    func addPauseButton(){
        let pauseButton = SKSpriteNode(imageNamed: "PauseIcon")
        pauseButton.size = CGSize(width: self.frame.width / 12 , height: self.frame.width / 12)
        // Name the start node for touch detection:
        pauseButton.name = "PauseBtn"
        pauseButton.zPosition = 20
        pauseButton.position = CGPoint(x: -cannon.cannonChargeIndicator.position.x, y: cannon.cannonChargeIndicator.position.y)
        
        addChild(pauseButton)
    }
    func makeExplosion(position: CGPoint, on parent: SKSpriteNode) {
        let fileName = parent.name == "enemy" ? "ExplosionYellow" : "Explosion"
        if let explosion = SKEmitterNode(fileNamed: fileName) {
            explosion.position = position
            self.addChild(explosion)
            if effects {
                run(explosionSound)
            }
            explosion.move(toParent: parent)
            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
            explosion.run(removeAfterDead)
        }
    }
    @objc func pauseGame() {
        print("game is paused!")
        self.run(SKAction.wait(forDuration: 0.0001)){
            self.pauseChilds(isPaused: true)
        }
        pause.zPosition = 30
        if self.childNode(withName: "pauseScreen") == nil {
            self.addChild(pause)
        }
    }
    
    func pauseChilds(isPaused: Bool){
        for child in children {
            child.isPaused = isPaused
        }
        self.backgroundMusicAV.setVolume(isPaused ? 0.2 : 0.5, fadeDuration: 0.5)
    }
    
    func setUpBgMusic(fileName: String){
        if self.backgroundMusicAV == nil {
            guard let backgroundMusicURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {return}
          do {
            let theme = try AVAudioPlayer(contentsOf: backgroundMusicURL)
              self.backgroundMusicAV = theme
          } catch {
            print("Couldn't load file")
          }
            backgroundMusicAV.prepareToPlay()
            self.backgroundMusicAV.numberOfLoops = -1
            self.backgroundMusicAV.volume = 0.5
        }
    }
    
    func startCalculatingMeterScore() {
        let wait = SKAction.wait(forDuration: 0.5)
        let addScore = SKAction.run {
            if self.player.isPaused == false{
            self.score += 0.01
                print(self.score)
            }
        }
        let sequence = SKAction.sequence([wait, addScore])
        self.run(SKAction.repeatForever(sequence))
    }
}
