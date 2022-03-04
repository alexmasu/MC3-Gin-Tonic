//
//  MenuScreen.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 22/02/22.
//
import AVFoundation
import SpriteKit

class MenuScreen: SKScene {
//    var intero = 0
    var music = true
    var effects = true
    let bgMusic = SKAudioNode(fileNamed: SoundFile.musicForMenu)
    override init(size: CGSize) {
        super.init(size: size)
        
        music = UserDefaults.standard.bool(forKey: "music")
        effects = UserDefaults.standard.bool(forKey: "effects")

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
        
        /*
         MUSIC BUTTON
         */
        let musicButton = LittleCircleNode(buttonType: .music, onOff: music)
        self.addChild(musicButton)
        
        /*
         Special Effects BUTTON
         */
        let specialEffectsButton = LittleCircleNode(buttonType: .effects, onOff: effects)
        self.addChild(specialEffectsButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let volumAct = SKAction.changeVolume(to: 0.7, duration: 0.1)
        bgMusic.run(volumAct)
        if music {
            self.addChild(bgMusic)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        // Find the location of the touch:
        let location = touch.location(in: self)
        // Locate the node at this location:
        let nodeTouched = atPoint(location)
        
        if nodeTouched.name == "Continue" {
            // Player touched the start text or button node
            // Switch to an instance of the GameScene:
            if let view = self.view {
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.size = view.frame.size
                    scene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 0.5)
//                    self.bgMusic.removeFromParent()
                    view.presentScene(scene, transition: transition)
                }
            }
        }
        
        if nodeTouched.name == "musicButton" {
            music.toggle()
            if music {
                addChild(bgMusic)
            } else {
                bgMusic.removeFromParent()
            }
            UserDefaults.standard.set(music, forKey: "music")
            guard let musicEffectsButton = nodeTouched as? LittleCircleNode else {return}
                musicEffectsButton.changeTextureOnOff(onOff: music)
        }
        if nodeTouched.name == "specialEffectsButton" {
            effects.toggle()
            UserDefaults.standard.set(effects, forKey: "effects")
            guard let specialEffectsButton = nodeTouched as? LittleCircleNode else {return}
                specialEffectsButton.changeTextureOnOff(onOff: effects)
        }
    }
}
