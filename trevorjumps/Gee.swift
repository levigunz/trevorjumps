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
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: texture.size().width / 2, height: texture.size().height / 2) )
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 10
        self.physicsBody?.collisionBitMask = Physics.Homework
        self.physicsBody?.categoryBitMask = Physics.Gee
        self.physicsBody?.contactTestBitMask = Physics.Homework | Physics.Bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot() {
        self.physicsBody?.applyImpulse(CGVector(dx: 10000, dy: 0))
    }
}
