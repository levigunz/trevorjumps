//
//  Player.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/18/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit

class Player : SKSpriteNode {
    
    init(x: CGFloat) {
        let texture = SKTexture(imageNamed: "trevor")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = "trevor"
        self.setScale(0.5)
        self.position.y = -60
        self.position.x = x
        self.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: self.size.width, height: self.size.height))
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.mass = 2.5
        self.physicsBody?.restitution = 0
        self.physicsBody?.collisionBitMask = Physics.Homework | Physics.Ammo | Physics.Health
        self.physicsBody?.categoryBitMask = Physics.Player
        self.physicsBody?.contactTestBitMask = Physics.Homework | Physics.Ammo | Physics.Health
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func jump() {
        //        self.texture = SKTexture(imageNamed: "player_jumping")
        if self.physicsBody?.velocity.dy == 0 {
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2500))
        }
    }
    
    func duck() {
        print("Nice try")
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -5000))
    }
    
    func shoot() {
        print("GEE!")
        let newGee = Gee()
        addChild(newGee)
        newGee.shoot()
    }
}
