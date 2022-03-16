//
//  MenuScene.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 15/02/22.
//

import SpriteKit
import AVFAudio

class GameOverScene: SKScene {
    var greenButtonTouched = false
    let musicSouldPlay = UserDefaults.standard.bool(forKey: "music")
    var effects = UserDefaults.standard.bool(forKey: "effects")
    var backgroundMusicAV : AVAudioPlayer!
    let popSound = SKAction.playSoundFileNamed(SoundFile.popButtons, waitForCompletion: true)

    init(size: CGSize, won:Bool, playerLife: Int) {

        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        makeBackground()
        makeAlien()
        makePlanet()
        makeGlass()
        setUpBgMusic(fileName: "Abi22i (online-audio-converter.com).mp3")
        
        // GREEN BUTTON NODE
        let greenButtonText = won ? "NEW GAME" : "RETRY"
        let greenButton = GreenButtonNode(nodeName: "GreenButton", buttonType: .screen, parentSize: size, text: greenButtonText)
        
        let maxScaledHeight = size.height * 0.08
        
        addChild(greenButton)
         
        /*
        
        // LITTLE LABEL ATTACHED TO GREEN BUTTON
        let littleLabelText = won ? "TO PLANET-2".localized() : "PLANET-1".localized()
        greenButton.addLittleLabel(text: littleLabelText, labelPosition: won ? .bottomLabel : .upperLabel)
         */
        
        /*
         Won/Game Over label definition
         */
        let message = won ? SKSpriteNode(imageNamed: "PLANET EXPLORED") : SKSpriteNode(imageNamed: "GAME OVER")
        message.anchorPoint = CGPoint(x: 0.5, y: 0)
        message.position = CGPoint(x: 0, y: maxScaledHeight * 1.1)
        addChild(message)

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
        
//        addChild(label2)
        
        /*
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
         */
        
        let blueButtonMessage = "BACK"
        let blueButton = GreenButtonNode(nodeName: "blueButton", buttonType: .screen, parentSize: size, text: blueButtonMessage.localized(), itsBlue: true)
        blueButton.position = CGPoint(x: 0 , y: greenButton.position.y - blueButton.size.height * 1.2)
            addChild(blueButton)
        
        if won {
            let stars = StarsNode(maxScaledHeight: maxScaledHeight, numOfStars: playerLife)
            addChild(stars)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        if musicSouldPlay{
            if !self.backgroundMusicAV.isPlaying {
                self.backgroundMusicAV.play()
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        // Find the location of the touch:
        let location = touch.location(in: self)
        // Locate the node at this location:
        let nodeTouched = atPoint(location)
        if nodeTouched.name == "GreenButton" {
            backgroundMusicAV.stop()
            greenButtonTouched = true
        }
        if nodeTouched.name == "blueButton" {
            if let view = self.view {
                let reveal = SKTransition.fade(withDuration: 0.5)
                let menuScene = MenuScreen(size: self.size)
                self.playTapSound(action: popSound, shouldPlayEffects: effects)
                backgroundMusicAV.stop()
                view.presentScene(menuScene, transition: reveal)
            }
        }
        if nodeTouched.name == "Restart" {
            if let view = self.view {
                let reveal = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.playTapSound(action: popSound, shouldPlayEffects: effects)
                backgroundMusicAV.stop()
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
                        self.playTapSound(action: popSound, shouldPlayEffects: effects)
                        view.presentScene(scene)
                    }
                }
            }
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
