//
//  Handicap.swift
//
//  Part IV of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 13/12/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//
//  New in part IV: So far we just had rings to fly trough. Now we introduce
//  handicaps which the plane should not touch. Otherwise it crashes and the
// game is over.

import SceneKit

// -----------------------------------------------------------------------------

class Handicap : GameObject {
    private var _boxNode: SCNNode!

    // -------------------------------------------------------------------------
    // MARK: - Propertiues
    
    override var description: String {
        get {
            return "handicap \(self.id)"
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Actions
    
    override func hit() {
        if self.state != .alive {
            return
        }
        
        self.state = .died

        let action1 = SCNAction.moveBy(x: 0, y: -3, z: 0, duration: 0.15)
        _boxNode.runAction(action1)
        
        let action2 = SCNAction.rotateBy(x: degreesToRadians(value: 30), y: 0, z: degreesToRadians(value: 15), duration: 0.3)
        _boxNode.runAction(action2)

        if let emitter = SCNParticleSystem(named: "art.scnassets/fire.scnp", inDirectory: nil) {
            self.addParticleSystem(emitter)
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    override init() {
        super.init()
        
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        let box = SCNBox(width: 4.0, height: 10.0, length: 2.0, chamferRadius: 0.0)
        box.materials = [boxMaterial]
        
        _boxNode = SCNNode(geometry: box)
        _boxNode.name = "handicap"
        _boxNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        _boxNode.physicsBody?.categoryBitMask = Game.Physics.Categories.enemy
        self.addChildNode(_boxNode)
        
        self.state = .alive
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}


