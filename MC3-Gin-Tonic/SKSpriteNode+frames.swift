//
//  SKSpriteNode+frames.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 23/02/22.
//

import SpriteKit

extension SKSpriteNode {
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
