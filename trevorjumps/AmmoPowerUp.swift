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
        self.setScale(0.125)
        self.position.x = UIScreen.main.bounds.width / 2 + self.size.width
        let y = Float.random(in: 0...spawnHeight)
        self.position.y = Bool.random() ? CGFloat(y) : CGFloat(-y)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: texture.size().width / 8, height: texture.size().height / 8) )
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 1
        self.physicsBody?.collisionBitMask = Physics.Gee
        self.physicsBody?.categoryBitMask = Physics.Ammo
        self.physicsBody?.contactTestBitMask = Physics.Gee | Physics.Player | Physics.Bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMove() {
        self.physicsBody?.applyImpulse(CGVector(dx: -1000, dy: 0))
    }
}
