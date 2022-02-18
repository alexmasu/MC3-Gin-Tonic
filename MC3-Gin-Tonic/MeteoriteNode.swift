//
//  MeteoriteNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 16/02/22.
//

import SpriteKit
import GameplayKit

class MeteoriteNode: SKSpriteNode {
    var life = 3
    
    init(minX: CGFloat, maxY: CGFloat) {
        let texture = SKTexture(imageNamed: "Meteorite")
        let startX = minX * 1.3
        let startY = CGFloat(Int.random(in: 20...Int(maxY + 20.0)))

        super.init(texture: texture, color: .white, size: texture.size())
        self.position = CGPoint(x: startX, y: startY)
        self.size = texture.size()
        self.name = "meteorite"
        
        physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody?.categoryBitMask = CollisionType.meteorite.rawValue
        physicsBody?.collisionBitMask = CollisionType.playerBullet.rawValue
        physicsBody?.contactTestBitMask = CollisionType.playerBullet.rawValue
        physicsBody?.mass = 10
        physicsBody?.angularVelocity = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving() {
        /*
        guard let scene = self.scene else {return}
        
        let rect = CGRect.init(x: 0, y: (-scene.frame.maxY / 2), width: scene.size.width, height: scene.size.width / 2)
        let node0 = SKShapeNode(rect: rect)
        node0.fillColor = .blue
        node0.zPosition = 20
        scene.addChild(node0)
        lazy var obstacleSpriteNodes = [scene.childNode(withName: "player") as! SKNode, node0]
        print(obstacleSpriteNodes.description)
         
        lazy var polygonObstacles: [GKPolygonObstacle] = SKNode.obstacles(fromNodeBounds: obstacleSpriteNodes)
        print(polygonObstacles.description)
        
        lazy var graph: GKObstacleGraph = GKObstacleGraph(obstacles: polygonObstacles, bufferRadius: 10)
        GKObstacleGraph(obstacles: self.polygonObstacles, bufferRadius: )
         */
        guard let scene = scene else {return}
        
        let endX = scene.frame.maxX * 1.2
        let endY = CGFloat(Int.random(in: 20...Int(scene.frame.maxY + 20.0)))
        let moveToEndPoint = SKAction.move(to: CGPoint(x: endX, y: endY), duration: Double.random(in: 6.0...9.5))
        let moveUp = SKAction.moveBy(x: 0, y: 30, duration: 1)
        let seq = SKAction.sequence([moveUp, moveUp.reversed()])
        let group = SKAction.group([SKAction.repeatForever(seq), moveToEndPoint])
//        self.run(SKAction.repeatForever(seq))
        self.run(group) {
            self.removeFromParent()
        }
    }
    
    func animateHit(metLife: Int) {
        var hitNum = 1
        switch metLife {
        case 2:
            hitNum = 2
        case 1:
            hitNum = 3
        default:
            break
        }
        
        let meteoriteAnimAtlas = SKTextureAtlas(named: "metHit\(hitNum)")
        var frames: [SKTexture] = []
        
        let numImages = meteoriteAnimAtlas.textureNames.count
        for i in 0...numImages - 1 {
            let metFrameName = "met\(i)@3x"
            frames.append(meteoriteAnimAtlas.textureNamed(metFrameName))
        }
        let animHit = SKAction.animate(with: frames, timePerFrame: 0.04, resize: true, restore: false)
        
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
