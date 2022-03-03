//
//  MenuScreen.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 22/02/22.
//

import SpriteKit
import AVKit
import Foundation


class MenuScreen: SKScene {
//    var intero = 0
    var music = true
    var effects = true

    override init(size: CGSize) {
        super.init(size: size)
        
        if UserDefaults.standard.contains(key: "music") {
            music = UserDefaults.standard.bool(forKey: "music")
        } else {
            music = true
        }
        
        if UserDefaults.standard.contains(key: "effects") {
            effects = UserDefaults.standard.bool(forKey: "effects")
        } else {
            effects = true
        }
        
//        music = UserDefaults.standard.bool(forKey: "music")
//        effects = UserDefaults.standard.bool(forKey: "effects")

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        makeBackground()
        makeGlass()
        makeAlien()
        makePlanet()
        
        // GREEN BUTTON NODE
        let continueButtonText = "CONTINUE"
        let continueButton = GreenButtonNode(nodeName: "Continue", buttonType: .screen, parentSize: size, text: continueButtonText)

        addChild(continueButton)
         
        // LITTLE LABEL ATTACHED TO GREEN BUTTON
        let littleLabelText = "PLANET-1"
        continueButton.addLittleLabel(text: littleLabelText, labelPosition: GreenButtonNode.labelPosition.upperLabel)

        let message = SKSpriteNode(imageNamed: "ABISSI")
        message.position = CGPoint(x: 0, y: -continueButton.position.y * 1.3)
        message.zPosition = 10
        let proportion = message.texture!.size().width / message.texture!.size().height
        let propW = continueButton.size.width * 1.2
        let propH = propW / proportion
        message.size = CGSize(width: propW, height: propH)
        
        self.addChild(message)
//        let tutorialStep = TutorialSpriteLabel()
//        self.addChild(tutorialStep)
        // 3
//        let label = SKLabelNode(fontNamed: "AdventPro-Bold")
//        label.text = message
//        label.fontSize = 60
//        label.fontColor = UIColor(rgb: 0xC5DC82)
//        label.position = CGPoint(x: 0, y: -continueButton.position.y * 1.5)
//        label.zPosition = 10
//        self.addChild(label)
        
        
        /*
         MUSIC BUTTON
         */
        let musicButton = SKSpriteNode(imageNamed: music ? "musicButton_on" :"musicButton_off")
        musicButton.size = CGSize(width: continueButton.size.height*0.7, height: continueButton.size.height*0.7)
        // Name the start node for touch detection:
        musicButton.name = "musicButton"
        musicButton.position = CGPoint(x: scene!.frame.maxX - musicButton.size.width, y: scene!.frame.maxY - musicButton.size.width)
        musicButton.zPosition = 300
        self.addChild(musicButton)
        
        
        /*
         Special Effects BUTTON
         */
        let specialEffectsButton = SKSpriteNode(imageNamed: effects ? "special_effects_on" : "special_effects_off" )
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
        
        if nodeTouched.name == "Continue" {
//            intero += 1
//            UserDefaults.standard.set(intero, forKey: "Intero")
//            print(intero, UserDefaults.standard.integer(forKey: "Intero"))
            UserDefaults.standard.removeObject(forKey: "Intero")
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
            music.toggle()
            UserDefaults.standard.set(music, forKey: "music")
            guard let musicEffectsButton = nodeTouched as? SKSpriteNode else {return}
                musicEffectsButton.texture = SKTexture(imageNamed: music ? "musicButton_on" : "musicButton_off")
        }
        if nodeTouched.name == "specialEffectsButton" {
            effects.toggle()
            UserDefaults.standard.set(effects, forKey: "effects")
            guard let specialEffectsButton = nodeTouched as? SKSpriteNode else {return}
                specialEffectsButton.texture = SKTexture(imageNamed: effects ? "special_effects_on" : "special_effects_off")
        }
    }
}
