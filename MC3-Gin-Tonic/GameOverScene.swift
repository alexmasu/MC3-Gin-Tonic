//
//  MenuScene.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 15/02/22.
//

import SpriteKit

class GameOverScene: SKScene {
    var greenButtonTouched = false
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        makeBackground()
        makeAlien()
        makePlanet()
        makeGlass()
        
        // GREEN BUTTON NODE
        let greenButtonText = won ? "CONTINUE" : "RETRY"
        let greenButton = GreenButtonNode(nodeName: "GreenButton", buttonType: .screen, parentSize: size, text: greenButtonText)
        if won {
            greenButton.position = .zero
        }
        addChild(greenButton)
         
        // LITTLE LABEL ATTACHED TO GREEN BUTTON
        let littleLabelText = won ? "TO PLANET-2".localized() : "PLANET-1".localized()
        greenButton.addLittleLabel(text: littleLabelText, labelPosition: won ? .bottomLabel : .upperLabel)
        let maxScaledHeight = size.height * 0.08
        
        /*
         Won/Game Over label definition
         */
        let message = won ? SKSpriteNode(imageNamed: "PLANET EXPLORED") : SKSpriteNode(imageNamed: "GAME OVER")
        message.position = CGPoint(x: 0, y: maxScaledHeight * 2)
        
//        let message2 = won ? "PLANET" : "GAME"

        //---maybe replace this two label with svg image for the stroke
        // SECOND LINE BIG LABEL
//        let label = SKLabelNode(fontNamed: "AdventPro-Bold")
//        label.text = message.localized()
//        label.verticalAlignmentMode = .center
//        label.horizontalAlignmentMode = .center
//        label.fontSize = maxScaledHeight * 1
//        label.fontColor = UIColor(named: "alienGreen")
//        label.position = CGPoint(x: 0, y: maxScaledHeight * 1)
       
        // FIRST LINE BIG LABEL
//        let label2 = SKLabelNode(fontNamed: "AdventPro-Bold")
//        label2.text = message2.localized()
//        label2.verticalAlignmentMode = .center
//        label2.horizontalAlignmentMode = .center
//        label2.fontSize = maxScaledHeight * 1
//        label2.fontColor = UIColor(named: "alienGreen")
//        label2.position = CGPoint(x: 0, y: maxScaledHeight * 2.2)
        
        addChild(message)
//        addChild(label2)
        guard let label = greenButton.childNode(withName: "littleLabel") as? SKLabelNode else {return}
        let labelPosition = label.convert(.zero, to: self)

        let littleButtonsSize = CGSize(width: greenButton.size.height, height: greenButton.size.height)
        
        let quitButton = SKSpriteNode(imageNamed: "settings")
        quitButton.size = littleButtonsSize
        // Name the start node for touch detection:
        quitButton.name = "QuitBtn"
        quitButton.anchorPoint = CGPoint(x: 0, y: 0.5)
        quitButton.position = CGPoint(x: greenButton.frame.minX, y: won ? labelPosition.y - quitButton.size.height / 1.2 : greenButton.position.y - quitButton.size.height * 1.2)
        quitButton.zPosition = 5
        
        self.addChild(quitButton)
        
        let settingsButton = SKSpriteNode(imageNamed: "restart button")
        settingsButton.size = littleButtonsSize
        // Name the start node for touch detection:
        settingsButton.name = "Restart"
        settingsButton.anchorPoint = CGPoint(x: 1, y: 0.5)
        settingsButton.position = CGPoint(x: greenButton.frame.maxX, y: quitButton.position.y)
        settingsButton.zPosition = 5
        
        
        self.addChild(settingsButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        // Find the location of the touch:
        let location = touch.location(in: self)
        // Locate the node at this location:
        let nodeTouched = atPoint(location)
        if nodeTouched.name == "GreenButton" {
            greenButtonTouched = true
        }
        if nodeTouched.name == "QuitBtn" {
            if let view = self.view {
                let reveal = SKTransition.fade(withDuration: 0.5)
                let menuScene = MenuScreen(size: self.size)
                
                view.presentScene(menuScene, transition: reveal)
            }
        }
        if nodeTouched.name == "Restart" {
            if let view = self.view {
                let reveal = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                
                view.presentScene(gameScene, transition: reveal)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if greenButtonTouched {
            guard let touch = touches.first else {return}
            // Find the location of the touch:
            let location = touch.location(in: self)
            // Locate the node at this location:
            let nodeTouched = atPoint(location)
            if nodeTouched.name == "GreenButton" {
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
