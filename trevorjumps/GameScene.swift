//
//  GameScene.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/18/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Physics {
    static let Player: UInt32 = 1
    static let Gee: UInt32 = 2
    static let Homework: UInt32 = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var trevor : Player!
    var gameTimer: Timer!
    
    override func didMove(to view: SKView) {
        print("Loaded the class")
        
        self.physicsWorld.contactDelegate = self
        
        guard let trevor = self.childNode(withName: "trevor") as? Player else {
            fatalError("Player not loaded")
        }
        
        let test = Homework()
        addChild(test)
        test.startMove()
        
        self.trevor = trevor
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {_ in
            self.addHomework()
        }
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        
//        print("Contact: ", contact.bodyA.categoryBitMask, ", ", contact.bodyB.categoryBitMask)
        
        if(contact.bodyA.categoryBitMask == Physics.Player && contact.bodyB.categoryBitMask == Physics.Homework) {
            self.endGame(a: contact.bodyA, b: contact.bodyB)
        }
        
        if(contact.bodyA.categoryBitMask == Physics.Homework && contact.bodyB.categoryBitMask == Physics.Player) {
            print("You dead")
        }
    }
    
    func addHomework() {
        let hw = Homework()
        addChild(hw)
        hw.startMove()
    }
    
    func endGame(a: SKPhysicsBody, b: SKPhysicsBody) {
        a.node?.run(
                SKAction.removeFromParent()
        )
        
        b.node?.run(
            SKAction.removeFromParent()
        )
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
