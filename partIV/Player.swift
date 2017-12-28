//
//  Player.swift
//
//  Part IV of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/07/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//
//  Part IV: Now the player objects is derrived from GameObject instead of SCNNode
//

import SceneKit

// -----------------------------------------------------------------------------

class Player : GameObject {
    private let lookAtForwardPosition = SCNVector3Make(0.0, -1.0, 6.0)
    private let cameraFowardPosition = SCNVector3(x: 0, y: 1.0, z: -5)

    private var _lookAtNode: SCNNode?
    private var _cameraNode: SCNNode?
    private var _playerNode: SCNNode?
    
    // -------------------------------------------------------------------------
    // MARK: - Propertiues
    
    override var description: String {
        get {
            return "player \(self.id)"
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Collision handling
    
    override func collision(with object: GameObject, level: GameLevel) {
        if let ring = object as? Ring {
            if ring.state != .alive {
                return
            }
            
            level.flyTrough(ring)
            ring.hit()
            
            self.roll()
        }
        else if let handicap = object as? Handicap {
            level.touchedHandicap(handicap)
            handicap.hit()
            
            self.die()
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Effects

    func die() {
        if self.state != .alive {
            return
        }
        
        self.state = .died
        _playerNode?.isHidden = true
        
        self.removeAllActions()
        _playerNode?.removeAllActions()
    }

    // -------------------------------------------------------------------------

    func roll() {
        // Part III: An easy effect we use, whenever we fly trough a ring
        let rotateAction = SCNAction.rotateBy(x: 0, y: 0, z: -degreesToRadians(value: 360.0), duration: 0.5)
        _playerNode!.runAction(rotateAction)
    }

    // -------------------------------------------------------------------------
    // MARK: - Camera adjustment

    private func toggleCamera() {
        var position = _cameraNode!.position

        if position.x < 0 {
            position.x = 0.5
        }
        else {
            position.x = -0.5
        }
    
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        
        _cameraNode?.position = position
        
        SCNTransaction.commit()
    }

    // -------------------------------------------------------------------------
    // MARK: - Plane movements
    
    func moveLeft() {
        let moveAction = SCNAction.moveBy(x: Game.Player.moveOffset, y: 0.0, z: 0, duration: 0.5)
        self.runAction(moveAction, forKey: "moveLeftRight")

        let rotateAction1 = SCNAction.rotateBy(x: 0, y: 0, z: -degreesToRadians(value: 15.0), duration: 0.25)
        let rotateAction2 = SCNAction.rotateBy(x: 0, y: 0, z: degreesToRadians(value: 15.0), duration: 0.25)

        _playerNode!.runAction(SCNAction.sequence([rotateAction1, rotateAction2]))
        
        toggleCamera()
    }
    
    // -------------------------------------------------------------------------
    
    func moveRight() {
        let moveAction = SCNAction.moveBy(x: -Game.Player.moveOffset, y: 0.0, z: 0, duration: 0.5)
        self.runAction(moveAction, forKey: "moveLeftRight")
        
        let rotateAction1 = SCNAction.rotateBy(x: 0, y: 0, z: degreesToRadians(value: 15.0), duration: 0.25)
        let rotateAction2 = SCNAction.rotateBy(x: 0, y: 0, z: -degreesToRadians(value: 15.0), duration: 0.25)
        
        _playerNode!.runAction(SCNAction.sequence([rotateAction1, rotateAction2]))
 
        toggleCamera()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    override init() {
        super.init()
        
        // Create player node
        let scene = SCNScene(named: "art.scnassets/ship.scn")
        if (scene == nil) {
            fatalError("Scene not loaded")
        }
        
        _playerNode = scene!.rootNode.childNode(withName: "ship", recursively: true)
        _playerNode?.name = "player"
        
        if (_playerNode == nil) {
            fatalError("Ship node not found")
        }
        
        _playerNode!.scale = SCNVector3(x: 0.25, y: 0.25, z: 0.25)
        self.addChildNode(_playerNode!)
        
        // Contact box
        // Part III: Instead of use the plane itself we add a collision node to the player object
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        let box = SCNBox(width: 2.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        box.materials = [boxMaterial]
        let contactBox = SCNNode(geometry: box)
        contactBox.name = "player"
        contactBox.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        contactBox.physicsBody?.categoryBitMask = Game.Physics.Categories.player
        contactBox.physicsBody!.contactTestBitMask = Game.Physics.Categories.ring | Game.Physics.Categories.enemy
        self.addChildNode(contactBox)

            // Look at Node
        _lookAtNode = SCNNode()
        _lookAtNode!.position = lookAtForwardPosition
        addChildNode(_lookAtNode!)
        
        // Camera Node
        _cameraNode = SCNNode()
        _cameraNode!.camera = SCNCamera()
        _cameraNode!.position = cameraFowardPosition
        _cameraNode!.camera!.zNear = 0.1
        _cameraNode!.camera!.zFar = 200
        self.addChildNode(_cameraNode!)
        
        // Link them
        let constraint1 = SCNLookAtConstraint(target: _lookAtNode)
        constraint1.isGimbalLockEnabled = true
        _cameraNode!.constraints = [constraint1]
        
        // Create a spotlight at the player
        let spotLight = SCNLight()
        spotLight.type = SCNLight.LightType.spot
        spotLight.spotInnerAngle = 40.0
        spotLight.spotOuterAngle = 80.0
        spotLight.castsShadow = true
        spotLight.color = UIColor.white
        let spotLightNode = SCNNode()
        spotLightNode.light = spotLight
        spotLightNode.position = SCNVector3(x: 1.0, y: 5.0, z: -2.0)
        self.addChildNode(spotLightNode)
        
        // Link it
        let constraint2 = SCNLookAtConstraint(target: self)
        constraint2.isGimbalLockEnabled = true
        spotLightNode.constraints = [constraint2]
        
        // Create additional omni light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.light!.color = UIColor.darkGray
        lightNode.position = SCNVector3(x: 0, y: 10.00, z: -2)
        self.addChildNode(lightNode)
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}
