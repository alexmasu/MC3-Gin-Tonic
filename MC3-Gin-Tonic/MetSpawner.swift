//
//  MetSpawner.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 27/02/22.
//

import SpriteKit

class MetSpawner : SKNode {
    var minYTouchingLimit: CGFloat = 0.0
    var maxYLimit: CGFloat = 300.0
    
    var startX = [CGFloat]()
    var startYLarge = [Int]()
    var startYSmaller = [Int]()
    
    var meteoriteLastSpawnTime: Double = 0

    let meteoriteTexture = SKTexture(imageNamed: "Meteorite0")
    let meteoriteAnimAtlas1 = SKTextureAtlas(named: "metHit1")
    let meteoriteAnimAtlas2 = SKTextureAtlas(named: "metHit2")
    let meteoriteAnimAtlas3 = SKTextureAtlas(named: "metHit3")
    var metSize = [CGSize]()
    
    
    func calculateMinYLimit(){
        let selfMaxSize = max(meteoriteTexture.size().width, meteoriteTexture.size().height)
        var playerMaxY: CGFloat {
            if let player = scene?.childNode(withName: "player") {
                return (player.frame.size.height / 1.8)
            } else {
                return 20.0
            }
        }
        minYTouchingLimit = selfMaxSize + playerMaxY
    }
    
    func calculateMaxYLimit(){
        guard let scene = scene else {return}
        maxYLimit = scene.frame.maxY - (scene.view!.safeAreaInsets.top + meteoriteTexture.size().height * 0.6)
    }
    func calculateMetSize(){
        guard let scene = scene else {return}
//        let metW_metH = meteoriteTexture.size().width / height
//
//        let proportionalWidthS = scene.size.width / 8
//        let propotionalHeightS = (scene.size.width / 8) * metW_metH
        let sizeS = scene.size.width / 12
        let sizeM = scene.size.width / 11
        let sizeL = scene.size.width / 10
        
        metSize.append(CGSize(width: sizeS, height: sizeS))
        metSize.append(CGSize(width: sizeM, height: sizeM))
        metSize.append(CGSize(width: sizeL, height: sizeL))
    }
    func configurePossibleStartXandY(){
        meteoriteTexture.preload {
        }
        meteoriteAnimAtlas1.preload {
        }
        meteoriteAnimAtlas2.preload {
        }
        meteoriteAnimAtlas3.preload {
        }
        
        calculateMetSize()
        

        calculateMaxYLimit()
        calculateMinYLimit()
        
        var stride1 = [Int]()
        for any in stride(from: 30, through: Int(maxYLimit), by: 5) {
            stride1.append(any)
        }
        startYLarge = stride1
        var stride2 = [Int]()
        for any in stride(from: Int(minYTouchingLimit), through: Int(maxYLimit), by: 5) {
            stride2.append(any)
        }
        startYSmaller = stride2
        guard let scene = scene else {return}
        let maxX = (scene.frame.maxX) * 1.2
        startX = [-maxX, maxX]
    }
    
    func calculateStartAndEndPoints() -> (start: CGPoint, end: CGPoint) {
        let xStart = CGFloat(startX.randomElement() ?? -250.0)
        let yStart = CGFloat(startYLarge.randomElement() ?? 300)
        let start = CGPoint(x: xStart, y: yStart)
        
        let xEnd = -xStart
        var yEnd = CGFloat()
        if yStart <= minYTouchingLimit {
            yEnd = CGFloat(startYSmaller.randomElement() ?? 300)
        } else {
            yEnd = CGFloat(startYLarge.randomElement() ?? 300)
        }
        let end = CGPoint(x: xEnd, y: yEnd)
        
        return (start, end)
    }
    
    enum PathType: CaseIterable {
        case line
        case oneCurve
        case twoCurves
    }
    
    func makeBezierPath(pathType: PathType) -> UIBezierPath {
        let startEnd = calculateStartAndEndPoints()
        let start = startEnd.start
        let end = startEnd.end
        
        let path = UIBezierPath()
        path.move(to: start)
        
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
    
    func spawnAndStartMoving() {
        if self.isPaused == false {
        let sizee = metSize.randomElement() ?? meteoriteTexture.size()
        let meteorite = MeteoriteNode(texture: meteoriteTexture, pSize: sizee, atlas1: meteoriteAnimAtlas1, atlas2: meteoriteAnimAtlas2, atlas3: meteoriteAnimAtlas3)
        
        let path = makeBezierPath(pathType: PathType.allCases.randomElement() ?? .line)

//        let pathNode = SKShapeNode(path: path.cgPath)
//            pathNode.strokeColor = SKColor.red
//            pathNode.lineWidth = 4
//        scene?.addChild(pathNode)
        
            let followPath = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat.random(in: 60*self.speed...100*self.speed))
        
        meteorite.run(followPath) {
            meteorite.removeFromParent()
        }
        scene?.addChild(meteorite)
    }
    }
    
    func endlessSpawning(){
        let waiting = SKAction.wait(forDuration: 6.0)
        let spawn = SKAction.run {
            self.spawnAndStartMoving()
        }
        let seq = SKAction.sequence([waiting, spawn])
        let endlessSpawn = SKAction.repeatForever(seq)
        self.run(endlessSpawn)
    }
    func startIncreasingSpeed(){
        let increase = SKAction.speed(by: 3, duration: 120)
        self.run(increase, withKey: "increasingEnemySpeed")
    }
}
