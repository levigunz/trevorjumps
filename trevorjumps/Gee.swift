//
//  Gee.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/21/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit

class Gee : SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "gee")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = "gee"
        self.setScale(0.5)
        self.physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width / 4)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 10
        self.physicsBody?.collisionBitMask = Physics.Homework
        self.physicsBody?.categoryBitMask = Physics.Gee
        self.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.5),
                SKAction.removeFromParent()
                ])
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot() {
        self.physicsBody?.applyImpulse(CGVector(dx: 2500, dy: 0))
    }
}
