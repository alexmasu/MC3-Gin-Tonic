//
//  MenuScene.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 15/02/22.
//

import SpriteKit

class GameOverScene: SKScene {
   override func didMove(to view: SKView) {
        if let particles = SKEmitterNode(fileNamed: "Stars") {
            particles.position = CGPoint(x: 300, y: 1080)
            particles.advanceSimulationTime(60)
            particles.zPosition = -1
            addChild(particles)
        }
    }
    init(size: CGSize, won:Bool) {
        
        
        super.init(size: size)
        // Build the start game button:
        //        restartButton.texture = SKTexture(imageNamed: "button")
        let restartButton = SKSpriteNode(imageNamed: "button")
        restartButton.size = CGSize(width: 295, height: 76)
        // Name the start node for touch detection:
        restartButton.name = "RestartBtn"
        restartButton.position = CGPoint(x: 200, y: 300)
        
        
        addChild(restartButton)
        
        let restartText = SKLabelNode(fontNamed:
                                        "AdventPro-Bold")
        
        let buttonMessage = won ? "Next Level" : "Retry"
        restartText.text = buttonMessage
        restartText.verticalAlignmentMode = .center
        restartText.position = .zero
        restartText.fontSize = 40
        restartText.fontColor = UIColor(rgb: 0x001273)
        // Name the text node for touch detection:
        restartText.name = "RestartBtn"
        restartText.zPosition = 5
        restartButton.addChild(restartText)
        
        //        backgroundColor = SKColor.blue
      
        
        let message = won ? "You Won!" : "Game Over"
        
        // 3
        let label = SKLabelNode(fontNamed: "AdventPro-Bold")
        label.text = message
        label.fontSize = 60
        label.fontColor = UIColor(rgb: 0xC5DC82)
        label.position = CGPoint(x: 200, y: 500)
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
