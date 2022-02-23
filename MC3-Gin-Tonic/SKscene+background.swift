//
//  SKscene+background.swift
//  MC3-Gin-Tonic
//
//  Created by Alessandro Masullo on 23/02/22.
//

import SpriteKit

extension SKScene {
    func makeBackground() {
        if let starsBackground = SKEmitterNode(fileNamed: "StarsBackground") {
            
            starsBackground.position = CGPoint(x: 0, y: self.frame.maxY + 50)
            
            starsBackground.zPosition = -1
            
            starsBackground.advanceSimulationTime(50)
            
            self.addChild(starsBackground)
        }
        self.backgroundColor = UIColor(rgb: 0x242548)
    }
    
    func makeAlien() {
        let alien = SKSpriteNode(imageNamed: "greenAlien")
        let scale = size.width / (alien.size.width * 2.4)
        alien.size = CGSize(width: alien.size.width * scale, height: alien.size.height * scale)
        alien.zPosition = 100
        alien.anchorPoint = CGPoint(x: 0.5, y: 0)
        let point = CGPoint(x: 0, y: (-size.height / 2) - alien.size.height * 0.3)
        alien.position = point
        addChild(alien)
    }
    
    func makePlanet() {
        let positionPoint = CGPoint(x: (-size.width / 2) * 0.8, y: (size.height / 2) * 0.88 )
        let planetIMG = SKSpriteNode(imageNamed: "planetImg")
        planetIMG.size = CGSize(width: size.width / 2.2, height: size.width / 2.2)
        planetIMG.position = positionPoint
        planetIMG.zPosition = 0
        addChild(planetIMG)
        
        //----DA SOSTITUIRE CON VIDEO
//        let planetGif = SKVideoNode(fileNamed: "")
//        planetGif.size = CGSize(width: size.width / 2.2, height: size.width / 2.2)
//        planetGif.position = positionPoint
//        addChild(planetGif)
//        planetGif.play()
    }
    
    func makeGlass() {
        let glass = SKShapeNode(rectOf: size)
        
        glass.fillColor = UIColor(named: "glassColor") ?? .white
        glass.alpha = 0.07
        glass.zPosition = 1
        addChild(glass)
    }
}
