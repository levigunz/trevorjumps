//
//  Player.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/18/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit

class Player : SKSpriteNode {
    
    func jump() {
        //        self.texture = SKTexture(imageNamed: "player_jumping")
        if self.physicsBody?.velocity.dy == 0 {
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
        }
    }
    
    func duck() {
        print("Nice try")
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -750))
    }
    
    func shoot() {
        print("GEE!")
        let newGee = Gee()
        addChild(newGee)
        newGee.shoot()
    }
}
