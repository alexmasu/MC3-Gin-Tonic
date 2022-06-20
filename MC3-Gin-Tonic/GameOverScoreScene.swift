//
//  MenuScene.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 13/06/22.
//

import SpriteKit
import AVFAudio

class GameOverScoreScene: SKScene {
    var greenButtonTouched = false
    let musicSouldPlay = UserDefaults.standard.bool(forKey: "music")
    var effects = UserDefaults.standard.bool(forKey: "effects")
    var backgroundMusicAV : AVAudioPlayer!
    let popSound = SKAction.playSoundFileNamed(SoundFile.popButtons, waitForCompletion: true)

    init(size: CGSize, score:Int, playerLife: Int) {

        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        makeBackground()
        makeAlien()
        makePlanet()
        makeGlass()
        setUpBgMusic(fileName: "Abi22i (online-audio-converter.com).mp3")
        
        // GREEN BUTTON NODE
        let greenButtonText = "NEW GAME"
        let greenButton = GreenButtonNode(nodeName: "GreenButton", buttonType: .screen, parentSize: size, text: greenButtonText)
        
        let maxScaledHeight = size.height * 0.08
        
        addChild(greenButton)
         
        let message = SKSpriteNode(imageNamed: "GAME OVER")
        message.anchorPoint = CGPoint(x: 0.5, y: 0)
        message.position = CGPoint(x: 0, y: maxScaledHeight * 2)
        addChild(message)

        let blueButtonMessage = "BACK"
        let blueButton = GreenButtonNode(nodeName: "blueButton", buttonType: .screen, parentSize: size, text: blueButtonMessage.localized(), itsBlue: true)
        blueButton.position = CGPoint(x: 0 , y: greenButton.position.y - greenButton.size.height * 1.2)
            addChild(blueButton)
        
//        let font = UIFont(name: "AdventPro-Bold", size: maxScaledHeight * 1)
//
//        let attributesString:[NSAttributedString.Key:Any] = [.strokeColor: UIColor.black, .strokeWidth: 2, .foregroundColor: UIColor(named: "alienGreen") ?? .green, .font: font ?? .monospacedSystemFont(ofSize: maxScaledHeight * 0.6, weight: .medium)]
//        let attributedString = NSMutableAttributedString(string: "SCORE: \(score)", attributes: attributesString)
        print(message.frame.origin.y)
        let positionLabel = (message.frame.minY + greenButton.frame.maxY)/2
        let scoreLabel = SKLabelNode(fontNamed: "AdventPro-Bold")
        scoreLabel.text = "SCORE"
        scoreLabel.verticalAlignmentMode = .bottom
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.fontSize = maxScaledHeight * 0.85
        scoreLabel.fontColor = UIColor(named: "glassColor")
        scoreLabel.position = CGPoint(x: 0, y: positionLabel + 10)
        scoreLabel.addStroke()
        
        let scoreLabel2 = SKLabelNode(fontNamed: "AdventPro-Bold")
        scoreLabel2.text = String(score)
        
        scoreLabel2.verticalAlignmentMode = .top
        scoreLabel2.horizontalAlignmentMode = .center
        scoreLabel2.fontSize = maxScaledHeight * 0.85
        scoreLabel2.fontColor = UIColor(named: "alienGreen")
        scoreLabel2.position = CGPoint(x: 0, y: -10)
        scoreLabel2.addStroke()
        scoreLabel.addChild(scoreLabel2)
        
        addChild(scoreLabel)
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

extension SKLabelNode {

   func addStroke() {

        guard let labelText = self.text else { return }

        let font = UIFont(name: self.fontName!, size: self.fontSize)

        let attributedString:NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

       let attributes:[NSAttributedString.Key:Any] = [.strokeColor: UIColor.black, .strokeWidth: -3, .font: font!, .foregroundColor: self.fontColor!]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
   }
}
