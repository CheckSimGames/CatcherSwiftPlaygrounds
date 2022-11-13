//
//  ContactNotifiable.swift
//  Catcher
//
//  Created by mark on 11/11/22.
//

import Foundation
import GameplayKit

/// Any entity that can handle collisions must conform to this protocol.
protocol ContactNotifiable {
    func contactDidBegin(with entity: GKEntity)
    func contactDidEnd(with entity: GKEntity)
}
