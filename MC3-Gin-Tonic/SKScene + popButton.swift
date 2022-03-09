//
//  SKScene + popButton.swift
//  MC3-Gin-Tonic
//
//  Created by Anna Izzo on 08/03/22.
//

import SpriteKit

extension SKScene {
    func playTapSound(action: SKAction, shouldPlayEffects: Bool) {
        if shouldPlayEffects {
            self.run(action)
        }
    }
}
