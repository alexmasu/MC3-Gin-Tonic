//
//  ShieldNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 11/02/22.
//

import SpriteKit

class ShieldNode: SKSpriteNode {

    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        let size = CGSize(width: texture.size().width / 1.5, height: texture.size().height / 1.1)
        
        super.init(texture: texture, color: .white, size: size)
        
        self.size = size
        name = "shield"
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        zPosition = 10
        physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        physicsBody?.categoryBitMask = CollisionType.shield.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = CollisionType.enemyWeapon.rawValue
        physicsBody?.isDynamic = true
        
        self.makeTextureShadow(blurRadius: 6, xScaleFactor: 1.6, yScaleFactor: 2.7, color: .cyan)
    }
    
    func animateHit() {
        let frames = makeAnimationFrames(from: "shieldHit")
        let animHit = SKAction.animate(with: frames, timePerFrame: 0.026, resize: false, restore: false)
        
        self.run(animHit)
        
        animateShadowGlow(withName: "shadow")
    }
    
    func openCannonAnimationRun() {
        let frames = makeAnimationFrames(from: "shieldAnim")
//        let framesReversed: [SKTexture] = frames.reversed()
//        frames.append(contentsOf: framesReversed)
//        let countFrames = Double(frames.count - 1)
//        let timePerFrames = 1 / countFrames
        let animCannon = SKAction.animate(with: frames, timePerFrame: 0.02, resize: false, restore: false)
        let scale = SKAction.scale(by: 3, duration: 0.25)
        
        self.run(scale)
        self.run(animCannon)
    }
    
    func closeCannonAnimationRun() {
        let frames = makeAnimationFrames(from: "shieldAnim")
        let framesReversed: [SKTexture] = frames.reversed()
        let animCannonReverse = SKAction.animate(with: framesReversed, timePerFrame: 0.02, resize: false, restore: false)
        let scale = SKAction.scale(to: 1, duration: 0.25)
        
        self.run(scale)
//        self.run(animCannon){
//            self.animateHit()
//        }
    }
    func openAndCloseAnimationRun() {
        let frames = makeAnimationFrames(from: "shieldAnim")
        let animCannon = SKAction.animate(with: frames, timePerFrame: 0.02, resize: false, restore: false)
        let scale = SKAction.scale(by: 3, duration: 0.25)
        
        let framesReversed: [SKTexture] = frames.reversed()
        let animCannonReverse = SKAction.animate(with: framesReversed, timePerFrame: 0.02, resize: false, restore: false)
        let scale2 = SKAction.scale(to: 1, duration: 0.25)
        let restore = SKAction.run {
            self.animateHit()
        }
        let seqRestore = SKAction.sequence([animCannonReverse, restore])
        
        self.run(scale)
        self.run(animCannon){
            self.run(scale2)
            self.run(seqRestore)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
