//
//  GameOver.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/22/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit

class GameOver : SKScene {
    
    override func didMove(to view: SKView) {
        print("GameOver loaded")
    }
    
    override internal func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "playAgain" {
                let newScene = SKScene(fileNamed: "GameScene")
                self.view?.presentScene(newScene)
            }
        }
    }
    
}
