//
//  SKSpriteNode+shadow.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 23/02/22.
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
}
