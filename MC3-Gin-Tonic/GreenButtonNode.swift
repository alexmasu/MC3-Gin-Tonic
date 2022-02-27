//
//  GreenButtonNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 23/02/22.
//

import SpriteKit

class GreenButtonNode: SKSpriteNode {
    
    let textNode = SKLabelNode(fontNamed: "AdventPro-Bold")

    enum buttonType {
        case screen, popUp
    }
    
    init(nodeName: String, buttonType: buttonType, parentSize: CGSize, text: String) {
        
        let maxScaledWidth = parentSize.width * (buttonType == .screen ? 0.40 : 0.52)
        let maxScaledHeight = parentSize.height * (buttonType == .screen ? 0.08 : 0.23)
        
        let texture = SKTexture(imageNamed: "button")
                
        super.init(texture: texture, color: .clear, size: parentSize)
                
        size = CGSize(width: maxScaledWidth, height: maxScaledHeight)
        // Name the start node for touch detection:
        name = nodeName
        zPosition = 10
        position = CGPoint(x: 0, y: buttonType == .screen ? -maxScaledHeight : 0)
        
        // Name the text node for touch detection:
        textNode.name = nodeName

        textNode.text = text.localized()
        textNode.verticalAlignmentMode = .center
        textNode.horizontalAlignmentMode = .center
        textNode.position = .zero
        textNode.fontSize = maxScaledWidth * 0.2
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
