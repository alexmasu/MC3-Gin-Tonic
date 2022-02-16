//
//  MenuScene.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 15/02/22.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let restartButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.size = CGSize(width: 300, height: 100)
        gameOver.position = CGPoint(x: 0, y: 100)
        self.addChild(gameOver)
        
        // Build the start game button:
        restartButton.texture = SKTexture(imageNamed: "button-restart")
        restartButton.size = CGSize(width: 295, height: 76)
        // Name the start node for touch detection:
        restartButton.name = "RestartBtn"
        restartButton.position = CGPoint(x: 0, y: -20)
        self.addChild(restartButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event:
                               UIEvent?) {
        for touch in (touches) {
            // Find the location of the touch:
            let location = touch.location(in: self)
            // Locate the node at this location:
            let nodeTouched = atPoint(location)
            if nodeTouched.name == "RestartBtn" {
                // Player touched the start text or button node
                // Switch to an instance of the GameScene:
                if let view = self.view {
                    if let scene = SKScene(fileNamed: "GameScene") {
                        scene.size = view.frame.size
                        scene.scaleMode = .aspectFill
                        
                        view.presentScene(scene)
                    }
                }
            }
        }
    }
}
