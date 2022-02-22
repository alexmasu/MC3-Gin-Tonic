//
//  ShieldNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 11/02/22.
//

import SpriteKit

extension SKSpriteNode {
    func makeTextureShadow(blurRadius: CGFloat, xScaleFactor: CGFloat? = 1.2, yScaleFactor: CGFloat? = 1.2, color: UIColor? = .white) {
        
        guard let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": blurRadius]),
        let texture = self.texture else {return}
        
        let blurredTexture = texture.applying(blurFilter)
        let shadow = SKSpriteNode(texture: blurredTexture)
        shadow.name = "shadow"
        shadow.size = CGSize(width: size.width * xScaleFactor!, height: size.height * yScaleFactor!)
        shadow.zPosition = -1
        shadow.color = color!
        shadow.blendMode = .alpha
        shadow.colorBlendFactor = 1
        shadow.alpha = 0.5
        
        let glowing = SKAction.fadeAlpha(to: 1, duration: 0.5)
        let glowing2 = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
        let glowSeq = SKAction.sequence([glowing, glowing2])
        shadow.run(SKAction.repeatForever(glowSeq))

        self.addChild(shadow)
    }
    
    func makeShapeGlow(cornerRadius: CGFloat? = 6, scaleSizeBy: CGFloat? = 0.4, color: UIColor? = .white) {
        let glow = SKShapeNode(rectOf: self.size, cornerRadius: cornerRadius!)
        
        glow.name = "glow"
        glow.setScale(scaleSizeBy!)
        glow.strokeColor = color!
        glow.alpha = 0.5
        glow.glowWidth = 20
        glow.zPosition = -1
        
        self.addChild(glow)
    }
    
    func makeAnimationFrames(from atlasName: String) -> [SKTexture] {
        let shieldAnimateAtlas = SKTextureAtlas(named: atlasName)
        var frames: [SKTexture] = []
        
        let numImages = shieldAnimateAtlas.textureNames.count
        for i in 1...numImages {
            let frameName = "\(atlasName)\(i)"
            shieldAnimateAtlas.textureNamed(frameName)
            frames.append(shieldAnimateAtlas.textureNamed(frameName))
        }
        return frames
    }
}

class ShieldNode: SKSpriteNode {
//    let emitterShield = SKEmitterNode(fileNamed: "ShieldBackGlow")

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
        
        animateShadowGlow()
    }
    
    func animateShadowGlow() {
        guard let shadow = self.childNode(withName: "shadow") else {return}
        let glowing = SKAction.fadeAlpha(to: 1, duration: 0.117)
        let glowing2 = SKAction.fadeAlpha(to: 0.5, duration: 0.117)
        let seq = SKAction.sequence([glowing, glowing2])
        
        guard let shadow2 = shadow.copy() as? SKSpriteNode else {return}
        shadow2.blendMode = .add
        self.addChild(shadow2)
        shadow2.run(seq) {
            shadow2.removeFromParent()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
