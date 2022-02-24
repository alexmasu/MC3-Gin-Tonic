//
//  GreenButtonNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 23/02/22.
//

import SpriteKit

class GreenButtonNode: SKSpriteNode {
    
    let textNode = SKLabelNode(fontNamed: "AdventPro-Bold")

    init(parentSize: CGSize, text: String) {
        
        let maxScaledWidth = parentSize.width * 0.40
        let maxScaledHeight = parentSize.height * 0.08
        
        let texture = SKTexture(imageNamed: "button")
                
        super.init(texture: texture, color: .clear, size: parentSize)
                
        size = CGSize(width: maxScaledWidth, height: maxScaledHeight)
        // Name the start node for touch detection:
        name = "GreenButton"
        zPosition = 10
        position = CGPoint(x: 0, y: -maxScaledHeight)
        
        // Name the text node for touch detection:
        textNode.name = "GreenButton"

        textNode.text = text.localized()
        textNode.verticalAlignmentMode = .center
        textNode.horizontalAlignmentMode = .center
        textNode.position = .zero
        textNode.fontSize = maxScaledHeight * 0.5
        textNode.fontColor = UIColor(rgb: 0x001273)
        textNode.zPosition = 20

        self.addChild(textNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    enum labelPosition {
        case upperLabel, bottomLabel
    }
    
    func addLittleLabel(text: String, labelPosition: labelPosition){
        //LITTLE PURPLE LABEL
        let littleLabel = SKLabelNode(fontNamed: "AdventPro-Bold")

        littleLabel.text = text.localized()
        littleLabel.verticalAlignmentMode = .center
        littleLabel.horizontalAlignmentMode = .center
        littleLabel.fontSize = self.textNode.fontSize * 0.7
        littleLabel.fontColor = UIColor(named: "labelPurple")
        
        littleLabel.position = CGPoint(x: 0, y: labelPosition == .bottomLabel ? (-self.size.height * 0.8) : (self.size.height / 1.2))
        
        self.addChild(littleLabel)
    }
}
