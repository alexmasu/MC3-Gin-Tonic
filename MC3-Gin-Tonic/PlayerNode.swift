//
//  PlayerNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 11/02/22.
//
import Foundation
import SpriteKit
import AudioToolbox

class PlayerNode: SKSpriteNode {
    
    var lastFiredTime: Double = 0
    var isFiring = false
    var life: Int = 3
    let bulletTexture = SKTexture(imageNamed: "playerBullet")
//    let screenSize = UIScreen.main.bounds.size

    init(imageNamed: String) {
        
        let texture = SKTexture(imageNamed: imageNamed)
//        let propotion = texture.size().height / texture.size().width
//        let newHeight_W = screenSize.height / 12.3629719854
//        let newWidth_H = newHeight_W * propotion
//        let adjustedSize = CGSize(width: newHeight_W, height: newWidth_H)

        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "player"
        position = CGPoint(x: 0, y: 0)
        zPosition = 10
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody?.categoryBitMask = CollisionType.player.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = CollisionType.enemyWeapon.rawValue
        physicsBody?.isDynamic = false
        makeTextureShadow(blurRadius: 5, xScaleFactor: 1.45, yScaleFactor: 1.45, color: .white, customTexture: nil)
        self.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: -90, upperLimit: 90))]
        bulletTexture.preload {
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum ControlType {
        case tapped, moved
    }
    
    func rotateControl(touchLocation: CGPoint, gestureType: ControlType) {
        guard let scene = scene else {return}
        guard scene.childNode(withName: "crop") == nil else {return}
        
//        let angle = atan2(-touchLocation.y, -touchLocation.x)
        //conversions: degreesToRadians = CGFloat.pi / 180 | radiansToDegrees = 180 / CGFloat.pi
        
//        let playerAngle = angle - (CGFloat.pi / 2)
        
//         angle = x * (-90 / maxX)
        let const = (CGFloat.pi / 2.25) / scene.frame.maxX
        let playerAngle = touchLocation.x * const
        
        switch gestureType {
        case .tapped:
            /*
             velocità angolare = deltaAngle/deltaTime -> deltaTime = angle/velocità
             */
            let rotation = SKAction.rotate(toAngle: playerAngle, duration: 0.12, shortestUnitArc: false)
            
            self.run(rotation) {
                self.isFiring = true
            }
        case .moved:
            let rotation = SKAction.rotate(toAngle: playerAngle, duration: 0.1, shortestUnitArc: false)
            self.run(rotation)
            self.isFiring = true
        }
    }
    
    func fire() {
        let playerBullet = SKSpriteNode(texture: bulletTexture)
        
        let playerAngleAdjusted = self.zRotation + CGFloat.pi / 2
        //Bullet angle adjusted
        let adjustedAngle = playerAngleAdjusted + CGFloat.pi / 2
        
        playerBullet.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playerBullet.size = CGSize(width: self.size.width / 6, height: self.size.height / 5)

        playerBullet.position = CGPoint(x: ((self.size.width / 2) * cos(playerAngleAdjusted)), y: ((self.size.width / 2) * sin(playerAngleAdjusted)))
        playerBullet.zPosition = 7
        playerBullet.zRotation = adjustedAngle
        
        playerBullet.physicsBody = SKPhysicsBody(rectangleOf: playerBullet.size)
        playerBullet.physicsBody?.categoryBitMask = CollisionType.playerBullet.rawValue
        playerBullet.physicsBody?.collisionBitMask = CollisionType.meteorite.rawValue
        playerBullet.physicsBody?.contactTestBitMask = CollisionType.meteorite.rawValue
        
        playerBullet.physicsBody?.mass = 0.02
        let speed: CGFloat = 18
        
        playerBullet.makeShapeGlow(cornerRadius: 10, scaleSizeBy: 0.7, color: .cyan)

        
        scene?.addChild(playerBullet)
        playerBullet.name = "playerBullet"

        let dx = speed * cos(playerAngleAdjusted)
        let dy = speed * sin(playerAngleAdjusted)
        playerBullet.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
                
        let scale = SKAction.scale(by: 1.06, duration: 0.07)
        let scaleSequence = SKAction.sequence([scale, scale.reversed()])
        
        //shield should not be child of player. Think about join them as separate objects.
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
    
    func reduceLife() {
        let vibration = SKAction.run {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        self.run(vibration)
        self.life -= 1
        if life != 0 {
        animateHit(playerLife: life)
        }
    }
    
    func animateHit(playerLife: Int) {
        let newTexture = SKTexture(imageNamed: "playerShip-\(playerLife)")
        let dumbPlayerCopy = SKSpriteNode(imageNamed: "playerShip-\(playerLife)")
        dumbPlayerCopy.size = self.size
        dumbPlayerCopy.zPosition = zPosition + 1
        dumbPlayerCopy.alpha = 0
        
//        let scale = SKAction.scale(by: 0.9, duration: 0.3)
//        let scaleSequence = SKAction.sequence([scale, scale.reversed()])
//        self.run(SKAction.repeat(scaleSequence, count: 3))
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.27)
        let seq = SKAction.sequence([fadeIn, fadeIn.reversed()])
        
        dumbPlayerCopy.run(SKAction.repeat(seq, count: 4)) {
            self.texture = newTexture
            dumbPlayerCopy.removeFromParent()
        }
        addChild(dumbPlayerCopy)
        self.animateShadowGlow(withName: "shadow")
        
        guard let shadow = self.childNode(withName: "shadow") as? SKSpriteNode else {return}
        shadow.run(SKAction.colorize(with: self.life == 2 ? (UIColor(rgb: 0x999900)) : .systemRed, colorBlendFactor: 1, duration: 0.2))
    }
    
    func shake(){
        let range : [CGFloat] = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]
        var randomShake = [SKAction]()
        for _ in 1...5 {
            let move1 = SKAction.move(to: CGPoint(x: range.randomElement() ?? 3, y: range.randomElement() ?? 3), duration: 0.03)
            let reset = SKAction.move(to: .zero, duration: 0.03)
            randomShake.append(move1)
            randomShake.append(reset)
        }
        self.run(SKAction.sequence(randomShake))
    }
    
    func animateEnergyPick() {
        makeShapeGlow(cornerRadius: 100, scaleSizeBy: 0.6, color: .systemYellow)
        guard let glow = self.childNode(withName: "glow") as? SKShapeNode else {return}
        glow.alpha = 1
        let act1 = SKAction.scale(to: 1.05, duration: 0.6)
        act1.timingMode = .easeOut
        glow.run(act1)
        let act2 = SKAction.fadeOut(withDuration: 0.4)
        glow.run(act2){
            glow.removeFromParent()
            glow.setScale(0.6)
        }
    }
}
