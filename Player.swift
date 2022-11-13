//
//  Player.swift
//  Catcher
//
//  Created by mark on 11/10/22.
//

import Foundation
import GameplayKit

class Player: GKEntity {
    let sprite = SpriteComponent()
    let transform = TransformComponent()
    var score = 0
    
    override init() {
        super.init()
        
        sprite.node = SKSpriteNode(color: .red, size: CGSize(width: 128, height: 128))
        addComponent(sprite)
        
        addComponent(transform)
        transform.set(node: sprite.node)
        
        let physicsComponent = PhysicsComponent(physicsBody: SKPhysicsBody(rectangleOf: CGSize(width: sprite.node.size.width, height: sprite.node.size.height)))
        physicsComponent.physicsBody.affectedByGravity = false
        addComponent(physicsComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Collision handling code
extension Player: ContactNotifiable {
    func contactDidBegin(with entity: GKEntity) {
        if entity is Food {
            score += 10
        }
    }
    
    func contactDidEnd(with entity: GKEntity) {
        
    }
}
