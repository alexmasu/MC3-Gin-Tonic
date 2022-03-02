//
//  MenuScreen.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 22/02/22.
//

import SpriteKit
import AVKit

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

// SAVE
let saveData = UserDefaults.standard
let loadData = UserDefaults.standard

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
        let littleLabelText = "PLANET-1"
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
        
        
        /*
         MUSIC BUTTON
         */
        let musicButton = SKSpriteNode(imageNamed: "musicButton_on")
        musicButton.size = CGSize(width: continueButton.size.height*0.7, height: continueButton.size.height*0.7)
        // Name the start node for touch detection:
        musicButton.name = "musicButton"
        musicButton.position = CGPoint(x: scene!.frame.maxX - musicButton.size.width, y: scene!.frame.maxY - musicButton.size.width)
        musicButton.zPosition = 300
        self.addChild(musicButton)
        
        
        /*
         Special Effects BUTTON
         */
        let specialEffectsButton = SKSpriteNode(imageNamed: "special_effects_on")
        specialEffectsButton.size = CGSize(width: continueButton.size.height*0.7, height: continueButton.size.height*0.7)
        // Name the start node for touch detection:
        specialEffectsButton.name = "specialEffectsButton"
        specialEffectsButton.position = CGPoint(x: musicButton.position.x, y: musicButton.position.y-musicButton.size.width*1.2)
        specialEffectsButton.zPosition = 600
        self.addChild(specialEffectsButton)
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
                    let transition = SKTransition.fade(withDuration: 0.5)
                    view.presentScene(scene, transition: transition)
                }
            }
        }
        
        if nodeTouched.name == "musicButton" {
            
            var temp: Bool = loadData.bool(forKey: "Abissi_Music_Setting")
            temp = !temp
            
            if temp {
                guard let button = nodeTouched as? SKSpriteNode else {return}
                button.texture = SKTexture(imageNamed: "musicButton_on")
            }
            else{
                guard let button = nodeTouched as? SKSpriteNode else {return}
                button.texture = SKTexture(imageNamed: "musicButton_off")
            }
            
            DispatchQueue.main.async {
                saveData.set(temp, forKey: "Abissi_Music_Setting")
            }
            
            print(loadData.bool(forKey: "Abissi_Music_Setting"))
        }
        
    }
}
