//
//  MeteoriteNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 16/02/22.
//

import SpriteKit

class MeteoriteNode: SKSpriteNode {
    var life = 3

    var meteoriteAnimAtlas1: SKTextureAtlas
    var meteoriteAnimAtlas2: SKTextureAtlas
    var meteoriteAnimAtlas3: SKTextureAtlas

    init(texture: SKTexture, pSize: CGSize, atlas1 : SKTextureAtlas, atlas2 : SKTextureAtlas, atlas3 : SKTextureAtlas){
        meteoriteAnimAtlas1 = atlas1
        meteoriteAnimAtlas2 = atlas2
        meteoriteAnimAtlas3 = atlas3

        super.init(texture: texture, color: .clear, size: pSize)
        name = "meteorite"
        self.makeTextureShadow(blurRadius: 5, xScaleFactor: 1.65, yScaleFactor: 1.65, customTexture: nil)

        physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        physicsBody?.categoryBitMask = CollisionType.meteorite.rawValue
        physicsBody?.collisionBitMask = CollisionType.playerBullet.rawValue
        physicsBody?.contactTestBitMask = CollisionType.playerBullet.rawValue
        physicsBody?.mass = 10
        physicsBody?.angularVelocity = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animateHit(metLife: Int) {
        var meteoriteAnimAtlas = meteoriteAnimAtlas1
        var hitNum = 1
        switch metLife {
        case 2:
            hitNum = 2
            meteoriteAnimAtlas = meteoriteAnimAtlas2
        case 1:
            hitNum = 3
            meteoriteAnimAtlas = meteoriteAnimAtlas3
        default:
            break
        }
        
        var frames: [SKTexture] = []
        
        let numImages = meteoriteAnimAtlas.textureNames.count
        for i in 1...numImages {
            let metFrameName = "metHit\(hitNum)\(i)"
            frames.append(meteoriteAnimAtlas.textureNamed(metFrameName))
        }
        let animHit = SKAction.animate(with: frames, timePerFrame: 0.04, resize: false, restore: false)
        
        self.animateShadowGlow(withName: "shadow")
        self.run(animHit) {
            if hitNum == 3 {
                self.animateEnergy()
                self.removeFromParent()
            }
        }
    }
    
    func animateEnergy() {
        if let energyParticles = SKEmitterNode(fileNamed: "MetEnergyParticles") {
            energyParticles.position = self.position
            
            energyParticles.particleSize = CGSize(width: self.size.width / 2, height: self.size.height / 2)
            
            energyParticles.particleAction = SKAction.move(to: .zero, duration: 1)

            scene?.addChild(energyParticles)
            energyParticles.run(energyParticles.particleAction!)

        }
    }
    
    func isDestroyedAfterHit() -> Bool {
        self.animateHit(metLife: self.life)

        self.life -= 1
        if self.life == 0 {
            return true
        } else {
            return false
        }
    }
}
