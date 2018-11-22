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
    var highScore: Int! = 0
    var highScoreLabel: SKLabelNode!
    var score: Int! = 0
    var scoreLabel: SKLabelNode!
    var ammo: Int! = 5
    var ammoLabel: SKLabelNode!
    var health: Int! = 3 {
    didSet {
        healthLabel.text = "Health:\n\(String(health))"
    }
    }
    var healthLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        print("Loaded the class")
        
        self.physicsWorld.contactDelegate = self
        
        guard let trevor = self.childNode(withName: "trevor") as? Player else {
            fatalError("Player not loaded")
        }
        
        let test = Homework()
        addChild(test)
        test.startMove()
        
        scoreLabel = SKLabelNode(text: "Score: \n" + String(score))
        scoreLabel.position.x = -50
        scoreLabel.position.y = 150
        addChild(scoreLabel)
        
        highScoreLabel = SKLabelNode(text: "High Score: \n" + String(highScore))
        highScoreLabel.position.x = -250
        highScoreLabel.position.y = 150
        addChild(highScoreLabel)
        
        ammoLabel = SKLabelNode(text: "Ammo: \n" + String(ammo))
        ammoLabel.position.x = 150
        ammoLabel.position.y = 150
        addChild(ammoLabel)
        
        healthLabel = SKLabelNode(text: "Health: \n" + String(health))
        healthLabel.position.x = 350
        healthLabel.position.y = 150
        addChild(healthLabel)
        
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
            health -= 1
        }
        
        if(contact.bodyA.categoryBitMask == Physics.Homework && contact.bodyB.categoryBitMask == Physics.Player) {
            health -= 1
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
