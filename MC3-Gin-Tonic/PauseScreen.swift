//
//  PauseScreen.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 21/02/22.
//

import SpriteKit

class PauseScreen: SKSpriteNode {
    
    init() {
        
//        if let particles = SKEmitterNode(fileNamed: "Stars") {
//            particles.position = CGPoint(x: 300, y: 1080)
//            particles.advanceSimulationTime(60)
//            particles.zPosition = -1
//            addChild(particles)
//        }
        super.init(texture: nil, color: .clear, size: CGSize(width: 270, height: 270))
        self.zPosition = 200
        let background = SKSpriteNode(imageNamed: "pausebg")
        background.zPosition = 1
        background.position = .zero
        addChild(background)
        
        let resumeButton = SKSpriteNode(imageNamed: "button")
        resumeButton.size = CGSize(width: 150, height: 60)
        // Name the start node for touch detection:
        resumeButton.name = "ResumeBtn"
        resumeButton.position = .zero
        resumeButton.zPosition = 5
        
        
        self.addChild(resumeButton)
        
        let resumeText = SKLabelNode(fontNamed:
                                        "AdventPro-Bold")
        
        let buttonMessage = "CONTINUE"
        resumeText.text = buttonMessage
        resumeText.verticalAlignmentMode = .center
        resumeText.position = .zero
        resumeText.fontSize = 32
        resumeText.fontColor = UIColor(rgb: 0x001273)
        // Name the text node for touch detection:
        resumeText.name = "ResumeBtn"
        resumeText.zPosition = 5
        resumeButton.addChild(resumeText)
        
        let quitButton = SKSpriteNode(imageNamed: "restart button")
        quitButton.size = CGSize(width: 60, height: 60)
        // Name the start node for touch detection:
        quitButton.name = "QuitBtn"
        quitButton.position = CGPoint(x: -45, y: -70)
        quitButton.zPosition = 5
        
        
        self.addChild(quitButton)
        
        let settingsButton = SKSpriteNode(imageNamed: "settings")
        settingsButton.size = CGSize(width: 60, height: 60)
        // Name the start node for touch detection:
        settingsButton.name = "SettingsBtn"
        settingsButton.position = CGPoint(x: 45, y: -70)
        settingsButton.zPosition = 5
        
        
        self.addChild(settingsButton)
        
//        let quitText = SKLabelNode(fontNamed:
//                                        "AdventPro-Bold")
//
//        let quitButtonMessage = "Quit"
//        quitText.text = quitButtonMessage
//        quitText.verticalAlignmentMode = .center
//        quitText.position = .zero
//        quitText.fontSize = 40
//        quitText.fontColor = UIColor(rgb: 0x001273)
//        // Name the text node for touch detection:
//        quitText.name = "QuitBtn"
//        quitText.zPosition = 5
//        quitButton.addChild(quitText)
        
        let message = "Pause"
        
        // 3
        let label = SKLabelNode(fontNamed: "AdventPro-Bold")
        label.text = message
        label.fontSize = 60
        label.fontColor = UIColor(rgb: 0xC5DC82)
        label.position = CGPoint(x: 0, y: 70)
        label.zPosition = 5
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event:
//                               UIEvent?) {
//        for touch in (touches) {
//            // Find the location of the touch:
//            let location = touch.location(in: self)
//            // Locate the node at this location:
////            let nodeTouched = atPoint(location)
////            if nodeTouched.name == "ResumeBtn" {
////                self.removeFromParent()
////                // Player touched the start text or button node
////                // Switch to an instance of the GameScene:
//////                if let view = self.view {
//////                    if let scene = SKScene(fileNamed: "GameScene") {
//////                        scene.size = view.frame.size
//////                        scene.scaleMode = .aspectFill
//////
//////                        view.presentScene(scene)
//////                    }
//////                }
////            }
//        }
//    }
}
