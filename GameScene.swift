//
//  GameScene.swift
//  Catcher Shared
//
//  Created by mark on 11/10/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player = Player()
    var foodList: Set<Food> = []
    var ground = Ground(width: 256)
    var dropSpeed = -4.0
    var spawnTimer = Timer()
    var dropSpeedTimer = Timer()
    var scoreLabel = SKLabelNode()
    
    func setupScene() {
        placePlayer()
        startTimers()
        setupLabel()
        setupGround()
        registerForNotifications()
        // You need to set the contact delegate for the collision detection functions in the extension to be called. Those functions are later in the file.
        physicsWorld.contactDelegate = self
    }
    
    func placePlayer() {
        // Center the player horizontally and place it 1/8 off the bottom of the screen.
        let startX = size.width / 2
        let startY = size.height / 8
        
        player.sprite.node.position = CGPoint(x: startX, y: startY)
        player.sprite.node.entity = player
        addChild(player.sprite.node)
    }
    
    func startTimers() {
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
            self.spawnFood()
        })
        
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: {_ in
            self.increaseDropSpeed()
        })
    }
    
    func spawnFood() {
        // Spawn the food at the top of the scene at a random horizontal spot.
        let spriteSize = 32
        // Keep the food from getting cut off the edges of the screen.
        let randomGenerator = GKRandomDistribution(lowestValue: spriteSize, highestValue: Int(size.width) - spriteSize)
        let x = randomGenerator.nextInt()
        let y = Int(size.height)
        
        let newFood = Food(location: CGPoint(x: x, y: y))
        newFood.sprite.node.position = CGPoint(x: x, y: y)
        
        // Set the food's entity so we don't have a nil entity when doing collision detection.
        newFood.sprite.node.entity = newFood
        
        foodList.insert(newFood)
        addChild(newFood.sprite.node)
    }
    
    func setupLabel() {
        scoreLabel.position.x = 32
        scoreLabel.position.y = size.height - 32
        scoreLabel.text = String(player.score)
        scoreLabel.fontColor = .black
        scoreLabel.fontName = "Helvetica Bold"
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
    }
        
    func setupGround() {
        // I'm doubling the width to work around a bug in the Mac version where the ground doesn't fill the whole width of the view when using self.size.width.
        ground = Ground(width: Int(self.size.width * 2))
        ground.sprite.node.entity = ground
        addChild(ground.sprite.node)
    }
    
    func registerForNotifications() {
        // When the food hits the ground, a notification of the event will be saved. Register for that notification here to restart the game.
        // In a real game you would show a Game Over screen with a button to play again.
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(restartGame(_:)), name: NSNotification.Name(rawValue: "FoodHitGround"), object: nil)
        
        center.addObserver(self, selector: #selector(removeFood(_:)), name: NSNotification.Name(rawValue: "FoodCaught"), object: nil)
    }
    
    override func didMove(to view: SKView) {
        self.setupScene()
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        dropFood()
    }
    
    func dropFood() {
        for food in foodList {
            food.transform.translate(CGVector(dx: 0, dy: dropSpeed))
        }
    }
    
    func increaseDropSpeed() {
        // Dropping is a negative number so to increase the speed, subtract.
        dropSpeed -= 0.5
    }
    
    // The @objc is needed because the function is called when a notification fires.
    @objc func restartGame(_ notification: NSNotification) {
        player.score = 0
        scoreLabel.text = String(player.score)
        
        for food in foodList {
            food.sprite.node.removeFromParent()
        }
        
        foodList.removeAll()
        dropSpeed = -4.0
    }
    
    @objc func removeFood(_ notification: NSNotification) {
        if let food = notification.object as? Food {
            foodList.remove(food)
            scoreLabel.text = String(player.score)
        }
    }
}

/// Collision code
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let entityA = contact.bodyA.node?.entity
        let entityB = contact.bodyB.node?.entity

        if let notifiableEntity = entityA as? ContactNotifiable, let otherEntity = entityB {
            notifiableEntity.contactDidBegin(with: otherEntity)
        }

        if let notifiableEntity = entityB as? ContactNotifiable, let otherEntity = entityA {
            notifiableEntity.contactDidBegin(with: otherEntity)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let entityA = contact.bodyA.node?.entity
        let entityB = contact.bodyB.node?.entity

        if let notifiableEntity = entityA as? ContactNotifiable, let otherEntity = entityB {
            notifiableEntity.contactDidEnd(with: otherEntity)
        }

        if let notifiableEntity = entityB as? ContactNotifiable, let otherEntity = entityA {
            notifiableEntity.contactDidEnd(with: otherEntity)
        }
    }
}
