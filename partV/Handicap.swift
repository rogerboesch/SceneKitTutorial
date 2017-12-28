//
//  Handicap.swift
//
//  Part 5 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 13/12/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import SceneKit

// -----------------------------------------------------------------------------

class Handicap : GameObject {
    private var _node: SCNNode!
    private var _height: CGFloat = 0
    
    // -------------------------------------------------------------------------
    // MARK: - Propertiues
    
    override var description: String {
        get {
            return "handicap \(self.id)"
        }
    }
    
    // -------------------------------------------------------------------------
    
    var height: CGFloat {
        get {
            return _height
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
        _node.runAction(action1)
        
        let action2 = SCNAction.rotateBy(x: degreesToRadians(value: 30), y: 0, z: degreesToRadians(value: 15), duration: 0.3)
        _node.runAction(action2)

        if let emitter = SCNParticleSystem(named: "art.scnassets/fire.scnp", inDirectory: nil) {
            self.addParticleSystem(emitter)
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    override init() {
        super.init()
        
        // Use some randomness in height, width and color
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.random(list: UIGreenColorList)
        
        let width = RBRandom.cgFloat(4.0, 9.0)
        _height = RBRandom.cgFloat(15.0, 25)
        
        var geometry: SCNGeometry!
        let rnd = RBRandom.integer(1, 3)
        if rnd == 1 {
            geometry = SCNBox(width: width, height: _height, length: 2.0, chamferRadius: 0.0)
        }
        else if rnd == 2 {
            geometry = SCNCylinder(radius: width, height: _height)
        }
        else {
            geometry = SCNCone(topRadius: 0.0, bottomRadius: width, height: _height)
        }
        
        geometry.materials = [material]
        
        _node = SCNNode(geometry: geometry)
        _node.name = "handicap"
        _node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        _node.physicsBody?.categoryBitMask = Game.Physics.Categories.enemy
        self.addChildNode(_node)
        
        self.state = .alive
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}


