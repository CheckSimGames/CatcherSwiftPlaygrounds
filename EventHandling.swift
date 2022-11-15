//
//  EventHandlingiOS.swift
//  Catcher
//
//  Created by mark on 11/10/22.
//

import Foundation
import SpriteKit

extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let deltaX = t.location(in: view).x - t.previousLocation(in: view).x
            player.transform.translate(CGVector(dx: deltaX, dy: 0.0))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {

        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
        }
    }
}
