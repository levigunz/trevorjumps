//
//  Homework.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/19/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit

let spawnHeight : Float = Float(UIScreen.main.bounds.height / 2) - 100

class Homework : SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "homework")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.position.x = UIScreen.main.bounds.width / 2 + self.size.width
        let y = Float.random(in: 0...spawnHeight)
        self.position.y = Bool.random() ? CGFloat(y) : CGFloat(-y)
        self.name = "homework"
        self.setScale(0.5)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 0.5
        self.physicsBody?.collisionBitMask = Physics.Gee
        self.physicsBody?.categoryBitMask = Physics.Homework
        self.physicsBody?.contactTestBitMask = Physics.Player | Physics.Gee | Physics.Bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMove() {
         self.physicsBody?.applyImpulse(CGVector(dx: -500, dy: 0))
    }
}
