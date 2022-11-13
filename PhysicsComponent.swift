//
//  PhysicsComponent.swift
//  Catcher
//
//  Created by mark on 11/11/22.
//

import Foundation
import SpriteKit
import GameplayKit

class PhysicsComponent: GKComponent {
    var physicsBody: SKPhysicsBody
    
    init(physicsBody: SKPhysicsBody) {
        self.physicsBody = physicsBody
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This function sets up the physics component when you add it to a GameplayKit entity. It sets the physics body type, sprite component, the sprite's physics body and the bit masks you need for collision detection to work correctly.
    override func didAddToEntity() {
        guard let entity = entity,
              let physicsBodyType = PhysicsBodyType.bodyType(for: entity),
              let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            fatalError("The entity needs a physics body type and a sprite component.")
        }
        
        physicsBody.categoryBitMask = physicsBodyType.categoryBitMask
        physicsBody.contactTestBitMask = physicsBodyType.contactTestBitMask
        physicsBody.collisionBitMask = 0
        
        spriteComponent.node.physicsBody = physicsBody
    }
}
