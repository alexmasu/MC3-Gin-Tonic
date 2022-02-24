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
    var minYTouchingLimit: CGFloat = 0.0
    init(minX: CGFloat, maxY: CGFloat) {
        let texture = SKTexture(imageNamed: "Meteorite")
        let startX = minX * (Bool.random() ? 1.3 : -1.3)
        let startY = CGFloat(Int.random(in: 20...Int(maxY)))

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
        
        makeTextureShadow(blurRadius: 6, xScaleFactor: 1.48, yScaleFactor: 1.48)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Calculates endPoint based on start position and scene limits (player, topSafeArea)
    func calculatedEndPoint() -> CGPoint {
        guard let scene = scene else {
            let endPoint = CGPoint(x: -position.x, y: position.y)
            return endPoint
        }
        let endX = -position.x
        let maxYLimit = Int(scene.frame.maxY - (scene.view!.safeAreaInsets.top + frame.height * 0.6))
        
        let selfMaxSize = max(frame.width, frame.height)
        var playerMaxY: CGFloat {
            if let player = scene.childNode(withName: "player") {
                return (player.frame.size.height / 2)
            } else {
                return 20.0
            }
        }
        minYTouchingLimit = selfMaxSize + playerMaxY
        
        var endY: CGFloat {
            if self.position.y <= minYTouchingLimit {
                return CGFloat(Int.random(in: Int(minYTouchingLimit)...maxYLimit))
            } else {
                return CGFloat(Int.random(in: 20...maxYLimit))
            }
        }
        
        let endPoint = CGPoint(x: endX, y: endY)
        return endPoint
    }
    
    enum PathType: CaseIterable {
        case line
        case oneCurve
        case twoCurves
    }
    
    func makeBezierPath(startPoint: CGPoint, endPoint: CGPoint, pathType: PathType) -> UIBezierPath {
        let end = endPoint
        let path = UIBezierPath()
        path.move(to: startPoint)
        
        guard let scene = scene else {
            path.addLine(to: end)
            return path }
        
        let maxX = scene.frame.maxX * 0.9
        let maxY = scene.frame.maxY - scene.view!.safeAreaInsets.top

        switch pathType {
        case .oneCurve:
            let control1 = CGPoint(x: CGFloat.random(in: -maxX...maxX), y: CGFloat.random(in: 20...maxY))
            path.addQuadCurve(to: end, controlPoint: control1)
        case .twoCurves:
            let control1 = CGPoint(x: CGFloat.random(in: -maxX...maxX), y: CGFloat.random(in: minYTouchingLimit...maxY))
            let control2 = CGPoint(x: CGFloat.random(in: -maxX...maxX), y: CGFloat.random(in: minYTouchingLimit...maxY))
            path.addCurve(to: end,
                          controlPoint1: control1,
                          controlPoint2: control2)
        default:
            path.addLine(to: end)
        }
        return path
    }
    
    func startMoving() {
//        guard let scene = scene else {
//            print("No scene found for meteorite")
//            return
//        }
        let endPoint = calculatedEndPoint()
        let path = makeBezierPath(startPoint: position, endPoint: endPoint, pathType: PathType.allCases.randomElement() ?? .line)

//        let pathNode = SKShapeNode(path: path.cgPath)
//            pathNode.strokeColor = SKColor.red
//            pathNode.lineWidth = 4
//        scene.addChild(pathNode)
        
        let followPath = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat.random(in: 80...110))
        
        self.run(followPath) {
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
