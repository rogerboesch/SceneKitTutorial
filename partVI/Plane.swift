//
//  Plane.swift
//
//  Part 6 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/07/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//
//  Part 6: Created a base class for planes
//

import SceneKit

// New in Part 6: We control the plane direction
enum PlaneDirection {
    case none, down, left, up, right
}

// -----------------------------------------------------------------------------

class Plane : GameObject {
    private var _modelNode: SCNNode?
    private var _collissionNode: SCNNode?

    private var _upDownDirection: PlaneDirection = .none       // Vertical direction
    private var _leftRightDirection: PlaneDirection = .none    // Side direction
    
    private var _speedDistance = Game.Plane.speedDistance      // The speed
    private var _flip = false                                  // If true then fly opposite direction
    
    private var _numberOfBullets = 0                           // Number of bullets available
    
    // -------------------------------------------------------------------------
    // MARK: - Propertiues
    
    override var description: String {
        get {
            return "plane \(self.id)"
        }
    }

    // -------------------------------------------------------------------------
    
    var leftRightDirection: PlaneDirection {
        get {
            return _leftRightDirection
        }
    }

    // -------------------------------------------------------------------------
    
    var upDownDirection: PlaneDirection {
        get {
            return _upDownDirection
        }
    }

    // -------------------------------------------------------------------------
    
    var modelNode: SCNNode? {
        get {
            return _modelNode
        }
    }

    // -------------------------------------------------------------------------
    
    var collissionNode: SCNNode? {
        get {
            return _collissionNode
        }
    }

    // -------------------------------------------------------------------------
    
    var flip: Bool {
        get {
            return _flip
        }
        set(value) {
            _flip = value
            
            if _flip {
                _speedDistance = -1*Game.Plane.speedDistance
                _modelNode?.eulerAngles = SCNVector3(0, degreesToRadians(value: 180.0), 0)
            }
            else {
                _speedDistance = Game.Plane.speedDistance
                _modelNode?.eulerAngles = SCNVector3(0, 0, 0)
            }
        }
    }

    // -------------------------------------------------------------------------
    
    var numberOfBullets: Int {
        get {
            return _numberOfBullets
        }
        set(value) {
            _numberOfBullets = value
            rbDebug("\(self) has \(_numberOfBullets) bullets left")
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Game loop

    override func update(atTime time: TimeInterval, level: GameLevel) {
        var eulerX: CGFloat = 0
        var eulerY: CGFloat = 0
        var eulerZ: CGFloat = 0
        
        if self.flip {
            eulerY = -degreesToRadians(value: 180)
        }
        
        // New in Part 5: We control minimum/maximum height
        if (_upDownDirection == .down) {
            if (self.position.y <= Game.Plane.minimumHeight) {
                stopMovingUpDown()
            }
            
            eulerX = degreesToRadians(value: Game.Plane.upDownAngle)
        }
        else if (_upDownDirection == .up) {
            if (self.position.y >= Game.Plane.maximumHeight) {
                stopMovingUpDown()
            }
            
            eulerX = -degreesToRadians(value: Game.Plane.upDownAngle)
        }
        
        // New in Part 5: We control minimum/maximum left/right
        if (_leftRightDirection == .left) {
            if (self.position.x >= Game.Plane.maximumLeft) {
                stopMovingLeftRight()
            }
            
            eulerZ = -degreesToRadians(value: Game.Plane.leftRightAngle)
        }
        else if (_leftRightDirection == .right) {
            if (self.position.x <= Game.Plane.maximumRight) {
                stopMovingLeftRight()
            }
            
            eulerZ = degreesToRadians(value: Game.Plane.leftRightAngle)
        }
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        
        _modelNode?.eulerAngles = SCNVector3(eulerX, eulerY, eulerZ)
        
        SCNTransaction.commit()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Collision handling
    
    override func collision(with object: GameObject, level: GameLevel) {
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Effects
    
    func die() {
        if self.state != .alive {
            return
        }
        
        self.state = .died
        _modelNode?.isHidden = true
        
        self.removeAllActions()
        _modelNode?.removeAllActions()

        if let emitter = SCNParticleSystem(named: "art.scnassets/smoke.scnp", inDirectory: nil) {
            self.addParticleSystem(emitter)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - New in Part 5: Move Actions
    
    func moveUp() {
        if _upDownDirection == .none {
            let moveAction = SCNAction.moveBy(x: 0, y: Game.Plane.upDownMoveDistance, z: 0, duration: 0.5)
            self.runAction(SCNAction.repeatForever(moveAction), forKey: "upDownDirection")
            
            _upDownDirection = .up
        }
        else if (_upDownDirection == .down) {
            self.removeAction(forKey: "upDownDirection")
            
            _upDownDirection = .none
        }
    }
    
    // -------------------------------------------------------------------------
    
    func moveDown() {
        if _upDownDirection == .none {
            let moveAction = SCNAction.moveBy(x: 0, y: -Game.Plane.upDownMoveDistance, z: 0, duration: 0.5)
            self.runAction(SCNAction.repeatForever(moveAction), forKey: "upDownDirection")
            
            _upDownDirection = .down
        }
        else if (_upDownDirection == .up) {
            self.removeAction(forKey: "upDownDirection")
            
            _upDownDirection = .none
        }
    }
    
    // -------------------------------------------------------------------------
    
    func stopMovingUpDown() {
        self.removeAction(forKey: "upDownDirection")
        _upDownDirection = .none
    }
    
    // -------------------------------------------------------------------------
    
    func moveLeft() {
        if _leftRightDirection == .none {
            let moveAction = SCNAction.moveBy(x: Game.Plane.leftRightMoveDistance, y: 0.0, z: 0, duration: 0.5)
            self.runAction(SCNAction.repeatForever(moveAction), forKey: "leftRightDirection")
            
            _leftRightDirection = .left
        }
        else if (_leftRightDirection == .right) {
            self.removeAction(forKey: "leftRightDirection")
            
            _leftRightDirection = .none
        }
    }
    
    // -------------------------------------------------------------------------
    
    func moveRight() {
        if _leftRightDirection == .none {
            let moveAction = SCNAction.moveBy(x: -Game.Plane.leftRightMoveDistance, y: 0.0, z: 0, duration: 0.5)
            self.runAction(SCNAction.repeatForever(moveAction), forKey: "leftRightDirection")
            
            _leftRightDirection = .right
        }
        else if (_leftRightDirection == .left) {
            self.removeAction(forKey: "leftRightDirection")
            
            _leftRightDirection = .none
        }
    }
    
    // -------------------------------------------------------------------------
    
    func stopMovingLeftRight() {
        self.removeAction(forKey: "leftRightDirection")
        _leftRightDirection = .none
    }
    
    // -------------------------------------------------------------------------
    
    override func start() {
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: _speedDistance, duration: Game.Plane.actionTime)
        let action = SCNAction.repeatForever(moveAction)
        self.runAction(action, forKey: "fly")
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
        
        _modelNode = scene!.rootNode.childNode(withName: "ship", recursively: true)
        _modelNode?.name = "plane"
        
        if (_modelNode == nil) {
            fatalError("Model node not found")
        }
        
        _modelNode!.scale = SCNVector3(x: 0.25, y: 0.25, z: 0.25)
        self.addChildNode(_modelNode!)
        
        // Contact box
        // Part 3: Instead of use the plane itself we add a collision node to the player object
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        let box = SCNBox(width: 2.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        box.materials = [boxMaterial]
        
        _collissionNode = SCNNode(geometry: box)
        _collissionNode!.name = "plane"
        _collissionNode!.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        _collissionNode!.physicsBody?.categoryBitMask = Game.Physics.Categories.player
        _collissionNode!.physicsBody!.contactTestBitMask = Game.Physics.Categories.ring | Game.Physics.Categories.enemy
        self.addChildNode(_collissionNode!)
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}

