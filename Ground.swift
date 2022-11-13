//
//  Ground.swift
//  Catcher
//
//  Created by mark on 11/11/22.
//

import Foundation
import GameplayKit

class Ground: GKEntity {
    let sprite = SpriteComponent()
    
    init(width: Int) {
        super.init()
        sprite.node = SKSpriteNode(color: .gray, size: CGSize(width: width, height: 32))
        sprite.node.position = CGPoint(x: 0, y: 0)
        // Set the anchor point to the left corner to make the ground sprite fill the width of the screen.
        sprite.node.anchorPoint = CGPoint(x: 0, y: 0)
        addComponent(sprite)
        
        // Have to set the center of the physics body to make the collision work on the whole bottom of the screen. Without it no collisions are detected on the right side of the screen.
        let body = SKPhysicsBody(rectangleOf: CGSize(width: sprite.node.size.width, height: sprite.node.size.height), center: CGPoint(x: sprite.node.size.width / 2, y: sprite.node.size.height / 2))
        let physicsComponent = PhysicsComponent(physicsBody: body)
        physicsComponent.physicsBody.affectedByGravity = false
        addComponent(physicsComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Collision handling code
extension Ground: ContactNotifiable {
    func contactDidBegin(with entity: GKEntity) {

    }
    
    func contactDidEnd(with entity: GKEntity) {
        
    }
}
