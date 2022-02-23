//
//  MenuScene.swift
//  MC3-Gin-Tonic
//
//  Created by Maria Smirnova on 15/02/22.
//

import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
//        if let particles = SKEmitterNode(fileNamed: "Stars") {
//            particles.position = CGPoint(x: 300, y: 1080)
//            particles.advanceSimulationTime(60)
//            particles.zPosition = -1
//            addChild(particles)
//        }
        makeBackground()
    }
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        // MAKE BACKGROUND FUNCTION
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let glass = SKShapeNode(rectOf: size)
        
        glass.fillColor = .white //hex: A4C6FA
        glass.alpha = 0.2
        addChild(glass)
        let maxScaledWidth = size.width * 0.6
        let maxScaledHeight = size.height * 0.1

        // Build the start game button:
        let restartButton = SKSpriteNode(imageNamed: "button")
        restartButton.size = CGSize(width: maxScaledWidth, height: maxScaledHeight)
        // Name the start node for touch detection:
        restartButton.name = "RestartBtn"
        restartButton.position = CGPoint(x: 0, y: -maxScaledHeight)
        
        addChild(restartButton)
        
        let restartText = SKLabelNode(fontNamed:
                                        "AdventPro-Bold")
        //should be CONTINUE and RETRY
        let buttonMessage = won ? "CONTINUE" : "RETRY"
        
        restartText.text = buttonMessage.localized()
        restartText.verticalAlignmentMode = .center
        restartText.horizontalAlignmentMode = .center
        restartText.position = .zero
        restartText.fontSize = maxScaledHeight * 0.5
        //font color hex: 001273
        restartText.fontColor = .black
        // Name the text node for touch detection:
        restartText.name = "RestartBtn"
        
        restartText.zPosition = 5
        
        restartButton.addChild(restartText)
        
        /*
         Won/Game Over label definition
         */
        //Should be PLANET EXPLORED : GAME OVER
        let message = won ? "EXPLORED" : "OVER"
        let message2 = won ? "PLANET" : "GAME"

        // 3
        let label = SKLabelNode(fontNamed: "AdventPro-Bold")
        label.text = message.localized()
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontSize = maxScaledHeight * 0.6
        label.fontColor = .systemGreen // hex: #C5DC82
        label.position = CGPoint(x: 0, y: maxScaledHeight * 1.5)
       
        let label2 = SKLabelNode(fontNamed: "AdventPro-Bold")
        label2.text = message2.localized()
        label2.verticalAlignmentMode = .center
        label2.horizontalAlignmentMode = .center
        label2.fontSize = maxScaledHeight * 0.6
        label2.fontColor = .systemGreen // hex: #C5DC82
        label2.position = CGPoint(x: 0, y: maxScaledHeight * 2.2)

        let label3 = SKLabelNode(fontNamed: "AdventPro-Bold")
        label3.text = won ? "TO PLANET-2".localized() : "PLANET-1".localized()
        label3.verticalAlignmentMode = .center
        label3.horizontalAlignmentMode = .center
        label3.fontSize = maxScaledHeight * 0.35
        label3.fontColor = .systemMint // hex: #C5DC82
        label3.position = CGPoint(x: 0, y: won ? (-maxScaledHeight * 1.8) : (maxScaledHeight * 0.2))
        
        addChild(label)
        addChild(label2)
        addChild(label3)
        makeAlien()
        makePlanet()
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
        if nodeTouched.name == "RestartBtn" {
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
    
    func makePlanet() {
        let positionPoint = CGPoint(x: (-size.width / 2) * 0.8, y: (size.height / 2) * 0.88 )
        let planetIMG = SKSpriteNode(imageNamed: "planetImg")
        planetIMG.size = CGSize(width: size.width / 2.2, height: size.width / 2.2)
        planetIMG.position = positionPoint
        addChild(planetIMG)
        
        //----DA SOSTITUIRE CON VIDEO
//        let planetGif = SKVideoNode(fileNamed: "")
//        planetGif.size = CGSize(width: size.width / 3.3, height: size.width / 3.3)
//        planetGif.position = positionPoint
//        addChild(planetGif)
//        planetGif.play()
    }
    
    func makeAlien() {
        let alien = SKSpriteNode(imageNamed: "greenAlien")
        let scale = size.width / (alien.size.width * 2.4)
        alien.size = CGSize(width: alien.size.width * scale, height: alien.size.height * scale)
        alien.zPosition = 30
        alien.anchorPoint = CGPoint(x: 0.5, y: 0)
        let point = CGPoint(x: 0, y: (-size.height / 2) - alien.size.height * 0.3)
        alien.position = point
        addChild(alien)
    }
    
}
