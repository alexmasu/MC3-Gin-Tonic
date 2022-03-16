//
//  StarsNode.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 16/03/22.
//

import SpriteKit

class StarsNode: SKNode {
    let greyStar1 = SKSpriteNode(imageNamed: "grayStar")
    let greyStar2 = SKSpriteNode(imageNamed: "grayStar")
    let greyStar3 = SKSpriteNode(imageNamed: "grayStar")
    let maxScaledHeight : CGFloat

    init(maxScaledHeight: CGFloat, numOfStars: Int) {
        self.maxScaledHeight = maxScaledHeight
        super.init()
        greyStar1.size = CGSize(width: maxScaledHeight * 1.2, height: maxScaledHeight * 1.2)
        greyStar2.size = greyStar1.size
        greyStar3.size = greyStar1.size

        greyStar2.position = CGPoint(x: 0, y: maxScaledHeight/2.9)
        greyStar1.position = CGPoint(x: -maxScaledHeight * 1.2, y: greyStar2.position.y)
        greyStar3.position = CGPoint(x: maxScaledHeight * 1.2, y: greyStar2.position.y)
        
        /* ----A random mistake lead me to a nice disposition:
         greyStar1.position = CGPoint(x: -maxScaledHeight * 1.2, y: greyStar1.position.y)
         greyStar2.position = CGPoint(x: 0, y: maxScaledHeight/2.9)
         greyStar3.position = CGPoint(x: maxScaledHeight * 1.2, y: greyStar1.position.y)
         */
        
        addChild(greyStar1)
        addChild(greyStar2)
        addChild(greyStar3)
        
        oneStarAppear(for: 1)
        if numOfStars > 1 {
            self.run(SKAction.wait(forDuration: 0.4)){
                self.oneStarAppear(for: 2)
            }
        }
        if numOfStars == 3 {
            self.run(SKAction.wait(forDuration: 0.8)){
                self.oneStarAppear(for: 3)
            }
        }
    }
    
    func oneStarAppear(for starNum: Int) {
        var starPosition: CGPoint {
            switch starNum {
            case 2:
                return greyStar2.position
            case 3:
                return greyStar3.position
            default:
                return greyStar1.position
            }
        }
        
        let yellowStar1 = SKSpriteNode(imageNamed: "yellowStar")
        yellowStar1.size = greyStar1.size
        yellowStar1.setScale(0)
        yellowStar1.position = starPosition
        yellowStar1.zPosition = 100
        
        let starsParticles = SKEmitterNode(fileNamed: "StarsParticles")!
        starsParticles.zPosition = -1

        let scaleAnim = SKAction.scale(to: 1, duration: 0.15)
        scaleAnim.timingMode = .easeIn
        addChild(yellowStar1)

        yellowStar1.run(scaleAnim)
        yellowStar1.addChild(starsParticles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
