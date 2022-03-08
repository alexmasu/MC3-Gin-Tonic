//
//  MenuScreen.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 22/02/22.
//

import AVFoundation
import SpriteKit



class MenuScreen: SKScene {

    var music = true
    var effects = true
//    let bgMusic = SKAudioNode(fileNamed: "Abi22i (online-audio-converter.com).mp3")
    let popSound = SKAction.playSoundFileNamed(SoundFile.popButtons, waitForCompletion: true)
    var backgroundMusicAV : AVAudioPlayer!
    override init(size: CGSize) {
        super.init(size: size)
        
        if UserDefaults.standard.contains(key: "music") {
            music = UserDefaults.standard.bool(forKey: "music")
        } else {
            music = true
            UserDefaults.standard.set(music, forKey: "music")
        }
        
        if UserDefaults.standard.contains(key: "effects") {
            effects = UserDefaults.standard.bool(forKey: "effects")
        } else {
            effects = true
            UserDefaults.standard.set(effects, forKey: "effects")
        }
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        makeBackground()
        makeGlass()
        makeAlien()
        makePlanet()
        setUpBgMusic(fileName: "Abi22i (online-audio-converter.com).mp3")

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

        if music {
            if !self.backgroundMusicAV.isPlaying {
              self.backgroundMusicAV.play()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        // Find the location of the touch:
        let location = touch.location(in: self)
        // Locate the node at this location:
        let nodeTouched = atPoint(location)
        
        if nodeTouched.name == "Continue" {
            self.playTapSound(action: popSound, shouldPlayEffects: effects)
            backgroundMusicAV.setVolume(0, fadeDuration: 0)

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
            self.playTapSound(action: popSound, shouldPlayEffects: effects)
            music.toggle()
            if music {
                backgroundMusicAV.setVolume(0.5, fadeDuration: 0)
            } else {
                backgroundMusicAV.setVolume(0, fadeDuration: 0)
            }
            UserDefaults.standard.set(music, forKey: "music")
            guard let musicEffectsButton = nodeTouched as? LittleCircleNode else {return}
                musicEffectsButton.changeTextureOnOff(onOff: music)
        }
        if nodeTouched.name == "specialEffectsButton" {
            self.playTapSound(action: popSound, shouldPlayEffects: effects)
            effects.toggle()
            UserDefaults.standard.set(effects, forKey: "effects")
            guard let specialEffectsButton = nodeTouched as? LittleCircleNode else {return}
                specialEffectsButton.changeTextureOnOff(onOff: effects)
        }
    }
    
    func setUpBgMusic(fileName: String){
        if self.backgroundMusicAV == nil {
            guard let backgroundMusicURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {return}
          do {
            let theme = try AVAudioPlayer(contentsOf: backgroundMusicURL)
              self.backgroundMusicAV = theme
          } catch {
            print("Couldn't load file")
          }
            backgroundMusicAV.prepareToPlay()
            self.backgroundMusicAV.numberOfLoops = -1
            self.backgroundMusicAV.volume = 0.5
        }
    }
}
