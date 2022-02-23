//
//  MenuScreen.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 22/02/22.
//

import SpriteKit

//extension UIColor {
//   convenience init(red: Int, green: Int, blue: Int) {
//       assert(red >= 0 && red <= 255, "Invalid red component")
//       assert(green >= 0 && green <= 255, "Invalid green component")
//       assert(blue >= 0 && blue <= 255, "Invalid blue component")
//
//       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//   }
//
//   convenience init(rgb: Int) {
//       self.init(
//           red: (rgb >> 16) & 0xFF,
//           green: (rgb >> 8) & 0xFF,
//           blue: rgb & 0xFF
//       )
//   }
//}

class MenuScreen: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        makeBackground()
        makeGlass()
        makeAlien()
        makePlanet()
        
        // GREEN BUTTON NODE
        let continueButtonText = "CONTINUE"
        let continueButton = GreenButtonNode(parentSize: size, text: continueButtonText)
        // Rename the start node for touch detection:

        addChild(continueButton)
         
        // LITTLE LABEL ATTACHED TO GREEN BUTTON
        let littleLabelText = "TO PLANET-1"
        continueButton.addLittleLabel(text: littleLabelText, labelPosition: .upperLabel)
        
        let message = "ABISSI"
        
        // 3
        let label = SKLabelNode(fontNamed: "AdventPro-Bold")
        label.text = message
        label.fontSize = 60
        label.fontColor = UIColor(rgb: 0xC5DC82)
        label.position = CGPoint(x: 0, y: -continueButton.position.y * 1.5)
        label.zPosition = 10
        self.addChild(label)
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
