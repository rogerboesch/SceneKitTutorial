//
//  Ring.swift
//
//  Part 3 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 13/12/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//
//  Rings are the first game elements (besides the player) introduced in this tutorial.
//  The goal is simple: Th eplayer must fly trough this rings and get one point for each.
//

import SceneKit

// -----------------------------------------------------------------------------

class Ring : SCNNode {
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    override init() {
        super.init()

        let ringMaterial = SCNMaterial()
        ringMaterial.diffuse.contents = UIImage(named: "art.scnassets/ringTexture")
        ringMaterial.diffuse.wrapS = .repeat
        ringMaterial.diffuse.wrapT = .repeat
        ringMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(3, 1, 1)

        let ring = SCNTorus(ringRadius: 5.0, pipeRadius: 0.5)
        ring.materials = [ringMaterial]
        let ringNode = SCNNode(geometry: ring)
        self.addChildNode(ringNode)

        ringNode.eulerAngles = SCNVector3(degreesToRadians(value: 90), 0, 0)
        
        let action = SCNAction.rotateBy(x: 0, y: 0, z: degreesToRadians(value: 360), duration: 3.0)
        ringNode.runAction(SCNAction.repeatForever(action))
        
        // Contact box
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)

        let box = SCNBox(width: 10.0, height: 10.0, length: 1.0, chamferRadius: 0.0)
        box.materials = [boxMaterial]
        let contactBox = SCNNode(geometry: box)
        contactBox.name = "ring"
        contactBox.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        contactBox.physicsBody?.categoryBitMask = Game.Physics.Categories.ring
        self.addChildNode(contactBox)
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}

