//
//  LittleCircleNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 03/03/22.
//

import SpriteKit

class LittleCircleNode: SKSpriteNode {
    let screenSize = UIScreen.main.bounds.size
//    var onOff: Bool
    let buttonType: CircleButtonType
    
    enum CircleButtonType {
        case music, effects
    }
    
    init(buttonType: CircleButtonType, onOff: Bool){
        self.buttonType = buttonType
//        self.onOff = onOff

        let sizes = CGSize(width: ((screenSize.height * 0.08) * 0.7), height: ((screenSize.height * 0.08) * 0.7))
        let xPosition = (screenSize.width / 2) - sizes.width
        let upperY = (screenSize.height / 2) - sizes.width
        let bottomY = upperY - (sizes.width * 1.2)
        let stringName1 = buttonType == .music ? "musicButton_" : "special_effects_"
        let string2 = onOff ? "on" : "off"
        let textur = SKTexture(imageNamed: stringName1 + string2)
        
        super.init(texture: textur, color: .clear, size: sizes)
        self.name = buttonType == .music ? "musicButton" : "specialEffectsButton"
        self.position = CGPoint(x: xPosition, y: buttonType == .music ? upperY : bottomY)
        self.zPosition = 300
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeTextureOnOff(onOff: Bool){
        if self.name == "musicButton" {
            self.texture = SKTexture(imageNamed: "musicButton_" + (onOff ? "on" : "off"))
        } else {
            self.texture = SKTexture(imageNamed: "special_effects_" + (onOff ? "on" : "off"))
        }
    }
}
