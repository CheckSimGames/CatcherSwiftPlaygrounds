//
//  PhysicsBodyType.swift
//  Catcher
//
//  Created by mark on 11/11/22.
//

import Foundation
import GameplayKit

struct PhysicsBodyType: OptionSet, Hashable {
    /// Need the raw value to set the category and contact bit masks for collision detection. Without collision detection, the player won't be able to collect the falling food, and the food won't hit the ground.
    let rawValue: UInt32

    static let player = PhysicsBodyType(rawValue: 1 << 0)
    static let food = PhysicsBodyType(rawValue: 1 << 1)
    static let ground = PhysicsBodyType(rawValue: 1 << 2)
    
    var categoryBitMask: UInt32 {
        return rawValue
    }
    
    var contactTestBitMask: UInt32 {
        let bitMask = PhysicsBodyType
            .contactTestNotifications[self]?
            .reduce(PhysicsBodyType(), { result, PhysicsBodyType in
                return result.union(PhysicsBodyType)
            })
        
        return bitMask?.rawValue ?? 0
    }
    /// Convenience method to get an entity's body type.
    static func bodyType(for entity: GKEntity) -> PhysicsBodyType? {
        switch entity {
        case is Player:
            return self.player
        case is Food:
            return self.food
        case is Ground:
            return self.ground
        default:
            return nil
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    /// This lists the entities that each entity can collide with.
    static var contactTestNotifications: [PhysicsBodyType: [PhysicsBodyType]] = [
    
        .player: [.food],
        .food: [.player, .ground]
    ]
}
