//
//  AsteroidNode.swift
//  MC3-Gin-Tonic
//
//  Created by Alessandro Masullo on 16/02/22.
//

import SpriteKit


class AsteroidNode: SKScene {
    
    let displaySize: CGRect = UIScreen.main.bounds
    
    let asteroideSpriteNode = SKSpriteNode(imageNamed: "demo")
    
    
    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        asteroidSpawner()
    }
    
    func asteroidSpawner(){
        
//        let asteroideSpriteNode = SKSpriteNode(imageNamed: "demo")
        
        //        let randomDoubleX = Double.random(in: frame.midX...frame.maxY)
        //
        //        let randomDoubleY = Double.random(in: frame.maxY...frame.maxY*2)
        
        //        asteroideSpriteNode.position = CGPoint(x: frame.maxX*(-1),y: frame.maxY)
        
        asteroideSpriteNode.position = CGPoint(x: displaySize.width*(-1)/4,
                                               y: displaySize.height)
        
        asteroideSpriteNode.size = CGSize(width: 50,
                                          height: 50)
        
        addChild(asteroideSpriteNode)
        
        asteroideSpriteNode.run(SKAction.move(to: CGPoint(x: displaySize.midX,
                                                          y: displaySize.midY),
                                              duration: 8.0))
        
    }
}
