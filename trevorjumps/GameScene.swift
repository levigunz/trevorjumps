//
//  GameScene.swift
//  trevorjumps
//
//  Created by Levi Gunsallus on 11/18/18.
//  Copyright © 2018 levigunz. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

struct Physics {
    static let Player: UInt32 = 1
    static let Gee: UInt32 = 2
    static let Homework: UInt32 = 4
    static let Ammo: UInt32 = 8
    static let Health: UInt32 = 16
    static let Bounds: UInt32 = 32
}

let screenHeight : Float = Float(UIScreen.main.bounds.height)
let screenWidth : Float = Float(UIScreen.main.bounds.width)

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var trevor : Player!
    var homeworkTimer: Timer!
    var ammoTimer: Timer!
    var healthTimer: Timer!
    var highScoreLabel: SKLabelNode!
    
    var score: Int! = 0 {
        didSet {
            scoreLabel.text = "Score: \n" + String(score)
        }
    }
    var scoreLabel: SKLabelNode!
    var ammo: Int! = 50 {
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
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: \n" + String(score))
        scoreLabel.position.x = -50
        scoreLabel.position.y = 150
        addChild(scoreLabel)
        
        highScoreLabel = SKLabelNode(text: "High Score: \n" + (UserDefaults.standard.string(forKey: "HIGHSCORE") ?? "0"))
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
        
        addBounds()
        addSwipeGestures()
    }
    
    func addBounds() {
        let leftBound : SKSpriteNode = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 1, height: Int(screenHeight)))
        leftBound.position.x = CGFloat(-screenWidth)
        leftBound.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leftBound.size.width, height: leftBound.size.height))
        leftBound.physicsBody?.affectedByGravity = false
        leftBound.physicsBody?.isDynamic = false
        leftBound.physicsBody?.allowsRotation = false
        leftBound.physicsBody?.mass = 2.5
        leftBound.physicsBody?.categoryBitMask = Physics.Bounds
        leftBound.physicsBody?.contactTestBitMask = Physics.Homework | Physics.Ammo | Physics.Health
        self.addChild(leftBound)
        
        //Get rid of this * 2; it is just because Trevor can jump off screen right now
        let rightBound : SKSpriteNode = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 1, height: Int(screenHeight * 2)))
        rightBound.position.x = CGFloat(screenWidth)
        rightBound.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rightBound.size.width, height: rightBound.size.height))
        rightBound.physicsBody?.affectedByGravity = false
        rightBound.physicsBody?.isDynamic = false
        rightBound.physicsBody?.allowsRotation = false
        rightBound.physicsBody?.mass = 2.5
        rightBound.physicsBody?.categoryBitMask = Physics.Bounds
        rightBound.physicsBody?.contactTestBitMask = Physics.Gee
        self.addChild(rightBound)
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
        //Sorting the bodies
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
            health == 0 ? self.endGame() : higherBody.node?.run(SKAction.removeFromParent())
        }
        
        //Gee & Homework
        if(lowerBody.categoryBitMask == Physics.Gee && higherBody.categoryBitMask == Physics.Homework) {
            score += 100
            let hs = UserDefaults.standard.integer(forKey: "HIGHSCORE")
            if (score > hs) {
                highScoreLabel.text = "High Score: \n" + String(score)
                //TODO: Noticable frame drop on first new score:/
            }
            lowerBody.node?.run(SKAction.removeFromParent())
            higherBody.node?.run(SKAction.removeFromParent())
        }
        
        //Player & AmmoUp
        if(lowerBody.categoryBitMask == Physics.Player && higherBody.categoryBitMask == Physics.Ammo) {
            higherBody.node?.run(SKAction.removeFromParent())
            ammo += 5
        }
        
        //Player & HealthUp
        if(lowerBody.categoryBitMask == Physics.Player && higherBody.categoryBitMask == Physics.Health) {
            higherBody.node?.run(SKAction.removeFromParent())
            if (health < 3) {
                health += 1
            }
        }
        
        //Bounds & Gee
        if(higherBody.categoryBitMask == Physics.Bounds && lowerBody.categoryBitMask == Physics.Gee) {
            lowerBody.node?.run(SKAction.removeFromParent())
        }
        
        //Bounds & Homework | Ammo | Health
        if(higherBody.categoryBitMask == Physics.Bounds && (lowerBody.categoryBitMask == Physics.Ammo || lowerBody.categoryBitMask == Physics.Health || lowerBody.categoryBitMask == Physics.Homework)) {
            lowerBody.node?.run(SKAction.removeFromParent())
        }
        
    }
    
    func addHomework() {
        let newHW = Homework()
        addChild(newHW)
        newHW.startMove()
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
        if(score! > UserDefaults.standard.integer(forKey: "HIGHSCORE")) {
            UserDefaults.standard.set(score!, forKey: "HIGHSCORE")
        }
        let newScene = SKScene(fileNamed: "GameOver")
        newScene?.userData = NSMutableDictionary()
        newScene?.userData?.setObject(String(score), forKey: "score" as NSCopying)
        self.view?.presentScene(newScene)
    }
    
    // TODO: See if using this override function is less costly than using the left and right bound physics
    
//    override func update(_ currentTime: TimeInterval) {
//        for node in children {
//            if ["homework", "gee", "ammoCoin", "heart"].contains(node.name) && !intersects(node) {
//                print("offscreen")
//                node.removeFromParent()
//            }
//        }
//    }
}
