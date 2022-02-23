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
        makeBackground()
        let continueButton = SKSpriteNode(imageNamed: "button")
        continueButton.size = CGSize(width: 295, height: 76)
        // Name the start node for touch detection:
        continueButton.name = "ContinueBtn"
        continueButton.position = CGPoint(x: 200, y: 300)
        
        
        self.addChild(continueButton)
        
        let continueText = SKLabelNode(fontNamed:
                                        "AdventPro-Bold")
        
        let buttonMessage = "CONTINUE"
        continueText.text = buttonMessage
        continueText.verticalAlignmentMode = .center
        continueText.position = .zero
        continueText.fontSize = 40
        continueText.fontColor = UIColor(rgb: 0x001273)
        // Name the text node for touch detection:
        continueText.name = "ContinueBtn"
        continueText.zPosition = 5
        continueButton.addChild(continueText)
        
        let message = "Abissi"
        
        // 3
        let label = SKLabelNode(fontNamed: "AdventPro-Bold")
        label.text = message
        label.fontSize = 60
        label.fontColor = UIColor(rgb: 0xC5DC82)
        label.position = CGPoint(x: 200, y: 500)
        label.zPosition = 5
        self.addChild(label)
        makeAlien()
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
            if nodeTouched.name == "ContinueBtn" {
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
