//
//  MenuScene.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 15/02/22.
//

import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        makeBackground()
    }
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        makeBackground()
        makeAlien()
        makePlanet()
        makeGlass()
        
        // GREEN BUTTON NODE
        let greenButtonText = won ? "CONTINUE" : "RETRY"
        let greenButton = GreenButtonNode(parentSize: size, text: greenButtonText)
        addChild(greenButton)
         
        // LITTLE LABEL ATTACHED TO GREEN BUTTON
        let littleLabelText = won ? "TO PLANET-2".localized() : "PLANET-1".localized()
        greenButton.addLittleLabel(text: littleLabelText, labelPosition: won ? .bottomLabel : .upperLabel)
        
        let maxScaledHeight = size.height * 0.08
        
        /*
         Won/Game Over label definition
         */
        let message = won ? "EXPLORED" : "OVER"
        let message2 = won ? "PLANET" : "GAME"

        //---maybe replace this two label with svg image for the stroke
        // SECOND LINE BIG LABEL
        let label = SKLabelNode(fontNamed: "AdventPro-Bold")
        label.text = message.localized()
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontSize = maxScaledHeight * 1
        label.fontColor = UIColor(named: "alienGreen")
        label.position = CGPoint(x: 0, y: maxScaledHeight * 1)
       
        // FIRST LINE BIG LABEL
        let label2 = SKLabelNode(fontNamed: "AdventPro-Bold")
        label2.text = message2.localized()
        label2.verticalAlignmentMode = .center
        label2.horizontalAlignmentMode = .center
        label2.fontSize = maxScaledHeight * 1
        label2.fontColor = UIColor(named: "alienGreen")
        label2.position = CGPoint(x: 0, y: maxScaledHeight * 2.2)
        
        addChild(label)
        addChild(label2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
