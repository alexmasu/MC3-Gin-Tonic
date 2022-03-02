//
//  TutorialSpriteLabel.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 01/03/22.
//

import SpriteKit

class TutorialSpriteLabel: SKSpriteNode {
    let screenSize = UIScreen.main.bounds.size
    let textureBG = SKTexture(imageNamed: "pausebg")
    let stepNum = 0
    init(){
        super.init(texture: textureBG, color: .clear, size: CGSize(width: screenSize.width * 0.75, height: screenSize.width * 0.75))
        self.zPosition = 200
        
        let resumeButton = GreenButtonNode(nodeName: "ResumeBtn", buttonType: .popUp, parentSize: self.size, text: "OK")
        resumeButton.name = "ResumeBtn"
        resumeButton.position = CGPoint(x: 0, y: -self.size.height / 4)
        self.addChild(resumeButton)
//        var message: String {
//            switch stepNum {
//            case 0:
//                return "Ruota la tua navicella scorrendo il dito in orizzontale nella parte bassa dello schermo. Alyn sparerà in automatico quando tieni il dito sullo schermo."
//            case 1:
//                "Prova a distruggere un meteorite colpendolo tre volte! Fai con calma, non ti colpiranno."
//            case 2:
//                "Ben fatto! Attenzione ora, arriva l'astronave nemica, ruota la navicella per difenderti dai suoi colpi con lo scudo blu."
//            case 3:
//                ""
//            case 4:
//            case 5:
//            default:
//                break
//            }
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
