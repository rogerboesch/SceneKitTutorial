//
//  Ring.swift
//
//  Part 4 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 13/12/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//
//  Part 4: Now the ring object is derrived from GameObject instead of SCNNode
//
import SceneKit
import RBSceneUIKit

// -----------------------------------------------------------------------------

class Ring : GameObject {
    
    // -------------------------------------------------------------------------
    // MARK: - Propertiues
    
    override var description: String {
        get {
            return "ring \(self.id)"
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Actions

    override func hit() {
        self.state = .died
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    override init() {
        super.init()

        let ringMaterial = SCNMaterial()
        ringMaterial.diffuse.contents = #imageLiteral(resourceName: "ringTexture")
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
        
        self.state = .alive
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}

