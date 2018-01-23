//
//  Ring.swift
//
//  Part 5 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 13/12/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import SceneKit
import RBSceneUIKit

// -----------------------------------------------------------------------------

class Ring : GameObject {
    private var _number: SCNNode!
    
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
        
        _number.isHidden = false
        _number.removeAllActions()
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(number: Int) {
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
        
        let action1 = SCNAction.rotateBy(x: 0, y: 0, z: degreesToRadians(value: 360), duration: 3.0)
        ringNode.runAction(SCNAction.repeatForever(action1))
        
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
        
        // New in Part 5: Add a number to the ring
        let numberMaterial = SCNMaterial()
        numberMaterial.diffuse.contents = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        let text = SCNText(string: "\(number)", extrusionDepth: 0.01)
        text.materials = [numberMaterial]
        _number = SCNNode(geometry: text)
        _number.eulerAngles = SCNVector3(0, degreesToRadians(value: 180), 0)
        _number.scale = SCNVector3(0.7, 0.7, 0.7)
        _number.position = SCNVector3(2.0, 4.5, -0.7)
        self.addChildNode(_number)

        let action2 = SCNAction.scale(to: 0.7, duration: 1.0)
        let action3 = SCNAction.scale(to: 1.0, duration: 1.0)
        let action4 = SCNAction.sequence([action2, action3])
        _number.runAction(SCNAction.repeatForever(action4))

        self.state = .alive
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}

