//
//  SKSpriteNode+shadow.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 23/02/22.
//

import SpriteKit

extension SKSpriteNode {
    
    func makeShieldShadow() {
        self.makeTextureShadow(blurRadius: 6, xScaleFactor: 1.65, yScaleFactor: 2.8, color: .cyan, customTexture: nil)
        guard let shadow = self.childNode(withName: "shadow") as? SKSpriteNode else {return}
        shadow.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    }
    func makeEnemyShadow() {
        self.makeTextureShadow(blurRadius: 15, xScaleFactor: 1.4, yScaleFactor: 1.45, color: .systemPurple, customTexture: SKTexture(imageNamed: "Group 190"))
        self.makeTextureShadow(blurRadius: 7, xScaleFactor: 1.1, yScaleFactor: 1.12, color: .systemGray6, customTexture: SKTexture(imageNamed: "enemyShadow3"))
    }
    
    func makeTextureShadow(blurRadius: CGFloat, xScaleFactor: CGFloat? = 1.2, yScaleFactor: CGFloat? = 1.2, color: UIColor? = .white, customTexture: SKTexture?) {
        
        guard let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": blurRadius]),
              let texture = self.texture else {return}
        let customTexture = customTexture ?? texture

        let blurredTexture = customTexture.applying(blurFilter)
        let shadow = SKSpriteNode(texture: blurredTexture)
        shadow.name = "shadow"
        shadow.size = CGSize(width: size.width * xScaleFactor!, height: size.height * yScaleFactor!)
        shadow.zPosition = -1
        shadow.color = color!
        shadow.blendMode = .alpha
        shadow.colorBlendFactor = 1
        shadow.alpha = 0.5
        
        let glowing = SKAction.fadeAlpha(to: 1, duration: 1)
        let glowing2 = SKAction.fadeAlpha(to: 0.5, duration: 1)
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
    
    func animateShadowGlow(withName: String) {
        guard let shadow = self.childNode(withName: withName) else {return}
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
}
