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
    static let Ammo: UInt32 = 8
    static let Health: UInt32 = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var trevor : Player!
    var homeworkTimer: Timer!
    var ammoTimer: Timer!
    var healthTimer: Timer!
    var highScore: Int! = 0
    var highScoreLabel: SKLabelNode!
    var score: Int! = 0 {
        didSet {
            scoreLabel.text = "Score: \n" + String(score)
        }
    }
    var scoreLabel: SKLabelNode!
    var ammo: Int! = 5 {
        didSet {
            ammoLabel.text = "Ammo: \n" + String(ammo)
        }
    }
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
        healthLabel.position.x = 300
        healthLabel.position.y = 150
        addChild(healthLabel)
        
        homeworkTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {_ in
            self.addHomework()
        }
        
        ammoTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: {_ in
            self.addAmmo()
        })
        
        healthTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block: {_ in
            self.addHealth()
        })
        
        self.trevor = Player(x: 175 - ((view.scene?.size.width)! / 2))
        addChild(self.trevor)
        
        addSwipeGestures()
    }
    
    func addSwipeGestures() {
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeUp))
        swipeUpRecognizer.direction = .up
        self.view!.addGestureRecognizer(swipeUpRecognizer)
        
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeDown))
        swipeDownRecognizer.direction = .down
        self.view!.addGestureRecognizer(swipeDownRecognizer)
    }
    
    @objc
    func handleSwipeDown(gesture: UISwipeGestureRecognizer) {
        let touch = gesture.location(in: view).x
        if(touch < ((view!.scene?.size.width)! / 2)) {
            trevor.duck()
        }
    }
    
    @objc
    func handleSwipeUp(gesture: UISwipeGestureRecognizer) {
        let touch = gesture.location(in: view).x
        if(touch < ((view!.scene?.size.width)! / 2)) {
            trevor.jump()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            let touch = t.location(in: self)
            if touch.x >= 0 {
                if (self.ammo > 0) {
                    self.ammo -= 1
                    trevor.shoot()
                } else {
                    print("Out of ammo :(")
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //TODO: Sort the two bodies before actually doing the comparisons to make destruction and comparison easier
        
        var lowerBody : SKPhysicsBody
        var higherBody : SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            lowerBody = contact.bodyA
            higherBody = contact.bodyB
        } else {
            lowerBody = contact.bodyB
            higherBody = contact.bodyA
        }
        
        //Player & Homework
        if(lowerBody.categoryBitMask == Physics.Player && higherBody.categoryBitMask == Physics.Homework) {
            health -= 1
            health == 0 ? self.endGame() : contact.bodyB.node?.run(SKAction.removeFromParent())
        }
        
        //Gee & Homework
        if(lowerBody.categoryBitMask == Physics.Gee && higherBody.categoryBitMask == Physics.Homework) {
            score += 100
            contact.bodyA.node?.run(SKAction.removeFromParent())
            contact.bodyB.node?.run(SKAction.removeFromParent())
        }
        
        //Player & AmmoUp
        if(lowerBody.categoryBitMask == Physics.Player && higherBody.categoryBitMask == Physics.Ammo) {
            
            //TODO: Destroy ammo animation
            higherBody.node?.run(SKAction.removeFromParent())
            
            ammo += 5
        }
        
        //Player & HealthUp
        if(lowerBody.categoryBitMask == Physics.Player && higherBody.categoryBitMask == Physics.Health) {
            
            //TODO: Destroy health animation
            higherBody.node?.run(SKAction.removeFromParent())
            
            if (health < 3) {
                health += 1
            }
            
        }
        
    }
    
    func addHomework() {
        let newHw = Homework()
        addChild(newHw)
        newHw.startMove()
    }
    
    func addHealth() {
        let newHealth = LifePowerUp()
        addChild(newHealth)
        newHealth.startMove()
    }
    
    func addAmmo() {
        let newAmmo = AmmoPowerUp()
        addChild(newAmmo)
        newAmmo.startMove()
    }
    
    func endGame() {
        self.removeAllChildren()
        let newScene = SKScene(fileNamed: "GameOver")
        self.view?.presentScene(newScene)
    }
}
