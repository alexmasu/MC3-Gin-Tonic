//
//  PauseScreen.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 21/02/22.
//

import SpriteKit

class PauseScreen: SKSpriteNode {
    
    init() {
        let screenSize = UIScreen.main.bounds.size
        let texture = SKTexture(imageNamed: "pausebg")
        super.init(texture: texture, color: .clear, size: CGSize(width: screenSize.width * 0.75, height: screenSize.width * 0.75))
        self.zPosition = 200
        self.name = "pauseScreen"
        
        let resumeButton = GreenButtonNode(nodeName: "ResumeBtn", buttonType: .popUp, parentSize: self.size, text: "CONTINUE")
        resumeButton.name = "ResumeBtn"
        self.addChild(resumeButton)
        
        let littleButtonsSize = CGSize(width: resumeButton.size.height, height: resumeButton.size.height)
        
        let quitButton = SKSpriteNode(imageNamed: "settings")
        quitButton.size = littleButtonsSize
        // Name the start node for touch detection:
        quitButton.name = "QuitBtn"
        quitButton.anchorPoint = CGPoint(x: 0, y: 0.5)
        quitButton.position = CGPoint(x: resumeButton.frame.minX, y: -size.height / 3.5)
        quitButton.zPosition = 10
        
        self.addChild(quitButton)
        
        let settingsButton = SKSpriteNode(imageNamed: "restart button")
        settingsButton.size = littleButtonsSize
        // Name the start node for touch detection:
        settingsButton.name = "SettingsBtn"
        settingsButton.anchorPoint = CGPoint(x: 1, y: 0.5)
        settingsButton.position = CGPoint(x: resumeButton.frame.maxX, y: -size.height / 3.5)
        settingsButton.zPosition = 5
        
        
        self.addChild(settingsButton)
        
        let message = SKSpriteNode(imageNamed: "Pause")
        message.position = CGPoint(x: 0, y: size.height / 3.5)
        message.zPosition = 5
        message.size = CGSize(width: resumeButton.size.width, height: resumeButton.size.height)
        
        addChild(message)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
