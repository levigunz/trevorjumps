//
//  MainMenu.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/18/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenu: SKScene {
    
    var playButton : SKLabelNode?
    
    override func didMove(to view: SKView) {
        print("Loaded MainMenu")
    }
    
    override internal func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "playButton" {
                print("play touched")
                let newScene = SKScene(fileNamed: "GameScene")
                self.view?.presentScene(newScene!)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

