//
//  PauseScreen.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 21/02/22.
//

import SpriteKit

class PauseScreen: SKScene {
    
    override func didMove(to view: SKView) {
        
        if let particles = SKEmitterNode(fileNamed: "Stars") {
            particles.position = CGPoint(x: 300, y: 1080)
            particles.advanceSimulationTime(60)
            particles.zPosition = -1
            addChild(particles)
        }
        
        let resumeButton = SKSpriteNode(imageNamed: "button")
        resumeButton.size = CGSize(width: 295, height: 76)
        // Name the start node for touch detection:
        resumeButton.name = "ResumeBtn"
        resumeButton.position = CGPoint(x: 200, y: 500)
        
        
        addChild(resumeButton)
        
        let resumeText = SKLabelNode(fontNamed:
                                        "AdventPro-Bold")
        
        let buttonMessage = "Resume"
        resumeText.text = buttonMessage
        resumeText.verticalAlignmentMode = .center
        resumeText.position = .zero
        resumeText.fontSize = 40
        resumeText.fontColor = .black
        // Name the text node for touch detection:
        resumeText.name = "ResumeBtn"
        resumeText.zPosition = 5
        resumeButton.addChild(resumeText)
        
        let quitButton = SKSpriteNode(imageNamed: "redButton")
        quitButton.size = CGSize(width: 295, height: 76)
        // Name the start node for touch detection:
        quitButton.name = "QuitBtn"
        quitButton.position = CGPoint(x: 200, y: 200)
        
        
        addChild(quitButton)
        
        let quitText = SKLabelNode(fontNamed:
                                        "AdventPro-Bold")
        
        let quitButtonMessage = "Quit"
        quitText.text = quitButtonMessage
        quitText.verticalAlignmentMode = .center
        quitText.position = .zero
        quitText.fontSize = 40
        quitText.fontColor = .black
        // Name the text node for touch detection:
        quitText.name = "QuitBtn"
        quitText.zPosition = 5
        quitButton.addChild(quitText)
    }
}
