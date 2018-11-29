//
//  AmmoPowerUp.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/23/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit

class AmmoPowerUp : SKSpriteNode{
    init() {
        let texture = SKTexture(imageNamed: "coin")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = "ammoCoin"
        self.setScale(0.5)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: texture.size().width / 2, height: texture.size().height / 2) )
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 10
        self.physicsBody?.collisionBitMask = Physics.Gee | Physics.Player
        self.physicsBody?.categoryBitMask = Physics.Ammo
        self.physicsBody?.contactTestBitMask = Physics.Gee | Physics.Player
        self.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 3),
                SKAction.removeFromParent()
                ])
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMove() {
        self.physicsBody?.applyImpulse(CGVector(dx: -1000, dy: 0))
    }
}
