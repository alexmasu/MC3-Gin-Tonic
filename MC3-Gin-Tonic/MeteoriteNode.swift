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
        self.run(moveToEndPoint) {
            self.removeFromParent()
        }
    }
    
    func isDestroyedAfterHit() -> Bool {
        self.life -= 1
        if self.life == 0 {
            return true
        } else {
            return false
        }
    }
}
