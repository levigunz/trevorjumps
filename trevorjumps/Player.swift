//
//  Player.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/18/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit

public class Player : SKSpriteNode {
    func jump() {
        print("Jumped!")
        //        self.texture = SKTexture(imageNamed: "player_jumping")
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
    }
    
    func shoot() {
        print("GEE!")
    }
    
    func duck() {
        print("Nice try")
    }
}
