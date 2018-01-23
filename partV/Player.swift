//
//  Player.swift
//
//  Part 5 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/07/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//

import SceneKit
import RBSceneUIKit

// New in Part 5: We control the plane direction
enum PlayerDirection {
    case none, down, left, up, right
}

// -----------------------------------------------------------------------------

class Player : GameObject {
    private let lookAtForwardPosition = SCNVector3Make(0.0, -1.0, 6.0)
    private let cameraFowardPosition = SCNVector3(x: 0, y: 1.0, z: -5)

    private var _lookAtNode: SCNNode?
    private var _cameraNode: SCNNode?
    private var _playerNode: SCNNode?

    // New in Part 5: We control the plane direction
    private var _upDownDirection: PlayerDirection = .none       // Vertical direction
    private var _leftRightDirection: PlayerDirection = .none    // Side direction

    // -------------------------------------------------------------------------
    // MARK: - Propertiues
    
    override var description: String {
        get {
            return "player \(self.id)"
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Game loop
    
    override func update(atTime time: TimeInterval, level: GameLevel) {
        var eulerX: CGFloat = 0
        var eulerZ: CGFloat = 0

        // New in Part 5: We control minimum/maximum height
        if (_upDownDirection == .down) {
            if (self.position.y <= Game.Player.minimumHeight) {
                stopMovingUpDown()
            }

            eulerX = degreesToRadians(value: Game.Player.upDownAngle)
        }
        else if (_upDownDirection == .up) {
            if (self.position.y >= Game.Player.maximumHeight) {
                stopMovingUpDown()
            }

            eulerX = -degreesToRadians(value: Game.Player.upDownAngle)
        }
        
        // New in Part 5: We control minimum/maximum left/right
        if (_leftRightDirection == .left) {
            if (self.position.x >= Game.Player.maximumLeft) {
                stopMovingLeftRight()
            }
            
            eulerZ = -degreesToRadians(value: Game.Player.leftRightAngle)
        }
        else if (_leftRightDirection == .right) {
            if (self.position.x <= Game.Player.maximumRight) {
                stopMovingLeftRight()
            }

            eulerZ = degreesToRadians(value: Game.Player.leftRightAngle)
        }

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        
        _playerNode?.eulerAngles = SCNVector3(eulerX, 0, eulerZ)

        SCNTransaction.commit()
    }

    // -------------------------------------------------------------------------
    // MARK: - Collision handling
    
    override func collision(with object: GameObject, level: GameLevel) {
        if self.state != .alive {
            return
        }

        if let ring = object as? Ring {
            if ring.state != .alive {
                return
            }
            
            level.flyTrough(ring)
            ring.hit()
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
    // MARK: - Camera adjustment

    private func adjustCamera() {
        // New in Part 5: move the camera according to the fly direction
        var position = _cameraNode!.position
        
        if (_leftRightDirection == .left) {
            position.x = 1.0
        }
        else if (_leftRightDirection == .right) {
            position.x = -1.0
        }
        else if (_leftRightDirection == .none) {
            position.x = 0.1
        }
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        
        _cameraNode?.position = position
        
        SCNTransaction.commit()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - New in Part 5: Move Actions
    
    func moveUp() {
        let oldDirection = _upDownDirection
        
        if _upDownDirection == .none {
            let moveAction = SCNAction.moveBy(x: 0, y: Game.Player.upDownMoveDistance, z: 0, duration: 0.5)
            self.runAction(SCNAction.repeatForever(moveAction), forKey: "upDownDirection")
            
            _upDownDirection = .up
        }
        else if (_upDownDirection == .down) {
            self.removeAction(forKey: "upDownDirection")
            
            _upDownDirection = .none
        }

        if oldDirection != _upDownDirection {
            adjustCamera()
        }
    }
    
    // -------------------------------------------------------------------------
    
    func moveDown() {
        let oldDirection = _upDownDirection
        
        if _upDownDirection == .none {
            let moveAction = SCNAction.moveBy(x: 0, y: -Game.Player.upDownMoveDistance, z: 0, duration: 0.5)
            self.runAction(SCNAction.repeatForever(moveAction), forKey: "upDownDirection")
            
            _upDownDirection = .down
        }
        else if (_upDownDirection == .up) {
            self.removeAction(forKey: "upDownDirection")
            
            _upDownDirection = .none
        }

        if oldDirection != _upDownDirection {
            adjustCamera()
        }
    }
    
    // -------------------------------------------------------------------------
    
    func stopMovingUpDown() {
        let oldDirection = _upDownDirection
        
        self.removeAction(forKey: "upDownDirection")
        _upDownDirection = .none

        if oldDirection != _upDownDirection {
            adjustCamera()
        }
    }
    
    // -------------------------------------------------------------------------
    
    func moveLeft() {
        let oldDirection = _leftRightDirection
        
        if _leftRightDirection == .none {
            let moveAction = SCNAction.moveBy(x: Game.Player.leftRightMoveDistance, y: 0.0, z: 0, duration: 0.5)
            self.runAction(SCNAction.repeatForever(moveAction), forKey: "leftRightDirection")
            
            _leftRightDirection = .left
        }
        else if (_leftRightDirection == .right) {
            self.removeAction(forKey: "leftRightDirection")
            
            _leftRightDirection = .none
        }

        if oldDirection != _leftRightDirection {
            adjustCamera()
        }
    }
    
    // -------------------------------------------------------------------------
    
    func moveRight() {
        let oldDirection = _leftRightDirection
        
        if _leftRightDirection == .none {
            let moveAction = SCNAction.moveBy(x: -Game.Player.leftRightMoveDistance, y: 0.0, z: 0, duration: 0.5)
            self.runAction(SCNAction.repeatForever(moveAction), forKey: "leftRightDirection")
            
            _leftRightDirection = .right
        }
        else if (_leftRightDirection == .left) {
            self.removeAction(forKey: "leftRightDirection")
            
            _leftRightDirection = .none
        }

        if oldDirection != _leftRightDirection {
            adjustCamera()
        }
    }
    
    // -------------------------------------------------------------------------
    
    func stopMovingLeftRight() {
        let oldDirection = _leftRightDirection
        
        self.removeAction(forKey: "leftRightDirection")
        _leftRightDirection = .none

        if oldDirection != _leftRightDirection {
            adjustCamera()
        }
    }

    // -------------------------------------------------------------------------

    func start() {
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: Game.Player.speedDistance, duration: Game.Player.actionTime)
        let action = SCNAction.repeatForever(moveAction)
        self.runAction(action, forKey: "fly")
    }

    // -------------------------------------------------------------------------

    override func stop() {
        super.stop()

        var position = _cameraNode!.position
        position.x = 0.0
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        
        _cameraNode?.position = position
        
        SCNTransaction.commit()
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
        // Part 3: Instead of use the plane itself we add a collision node to the player object
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
        _cameraNode!.camera!.zFar = 600
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
        spotLightNode.position = SCNVector3(x: 0.0, y: 25.0, z: -1.0)
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
        lightNode.position = SCNVector3(x: 0, y: 100.00, z: -2)
        self.addChildNode(lightNode)
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}
