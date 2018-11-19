//
//  GameScene.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/18/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var trevor : Player?
    
    override func didMove(to view: SKView) {
        print("Loaded the class")
        
        guard let trevor = self.childNode(withName: "trevor") as? Player else {
            fatalError("Player not loaded")
        }
        
        self.trevor = trevor
        
        self.trevor!.jump()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            let touch = t.location(in: self)
            if touch.x >= 0 {
                trevor?.shoot()
            } else {
                if touch.y >= 0 {
                    trevor?.jump()
                } else {
                    trevor?.duck()
                }
            }
        }
        
    }
}
