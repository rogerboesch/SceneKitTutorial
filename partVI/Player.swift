//
//  Player.swift
//
//  Part 6 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/07/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//

import SceneKit

// -----------------------------------------------------------------------------

class Player : Plane {
    private let lookAtForwardPosition = SCNVector3Make(0.0, -1.0, 6.0)
    private let cameraFowardPosition = SCNVector3(x: 0, y: 1.0, z: -5)

    private var _lookAtNode: SCNNode?
    private var _cameraNode: SCNNode?

    private var _crashed = false
    
    // -------------------------------------------------------------------------
    // MARK: - Propertiues
    
    override var description: String {
        get {
            return "player \(self.id)"
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Actions
    
    func fire(_ level: GameLevel) {
        if self.numberOfBullets == 0 {
            rbDebug("\(self) has no bullets anymore")
            return
        }
        
        var position = self.position
        position.z = position.z + 1.0
        
        GameSound.fire(self)
        
        var y: CGFloat = 0
        if self.upDownDirection == .up {
            y = 20
        }
        else if self.upDownDirection == .down {
            y = -20
        }
        
        var x: CGFloat = 0
        if self.leftRightDirection == .left {
            x = 40
        }
        else if self.leftRightDirection == .right {
            x = -40
        }

        // Create bullet and fire
        self.numberOfBullets -= 1
        let bullet = level.fireBullet(enemy: false, position: position, sideDistance: x, fallDistance: y)

        rbDebug("\(self) has fired bullet \(bullet)")
    }

    // -------------------------------------------------------------------------

    override func hit() {
        if let emitter = SCNParticleSystem(named: "art.scnassets/smoke.scnp", inDirectory: nil) {
            self.addParticleSystem(emitter)
        }
        
        _crashed = true
        
        moveDown()
        moveDown()

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        
        self.modelNode?.eulerAngles = SCNVector3(degreesToRadians(value: 40.0), degreesToRadians(value: 0.0), 0)
        
        SCNTransaction.commit()
    }

    // -------------------------------------------------------------------------
    // MARK: - Game loop

    override func update(atTime time: TimeInterval, level: GameLevel) {
        if !_crashed {
            super.update(atTime: time, level: level)
            return
        }
        
        if (self.position.y <= Game.Plane.crashHeight) {
            self.die()
            self.modelNode?.isHidden = false
 
            GameSound.explosion(self)

            level.crashed()
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Collision handling
    
    override func collision(with object: GameObject, level: GameLevel) {
        if self.state != .alive {
            return
        }

        if let ring = object as? Ring {
            rbDebug("\(self) collided with \(object)")

            if ring.state != .alive {
                return
            }

            GameSound.bonus(self)

            level.flyTrough(ring)
            ring.hit()
        }
        else if let handicap = object as? Handicap {
            if handicap.state != .alive {
                return
            }

            rbDebug("\(self) collided with \(object)")

            GameSound.explosion(self)

            level.touchedHandicap(handicap)
            handicap.hit()

            self.die()
        }
        else if let enemy = object as? Enemy {
            if enemy.state != .alive {
                return
            }

            rbDebug("\(self) collided with \(object)")

            GameSound.explosion(self)

            enemy.hit()
            self.hit()
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Camera adjustment

    private func adjustCamera() {
        // New in Part 5: move the camera according to the fly direction
        var position = _cameraNode!.position
        
        if (self.leftRightDirection == .left) {
            position.x = 1.0
        }
        else if (self.leftRightDirection == .right) {
            position.x = -1.0
        }
        else if (self.leftRightDirection == .none) {
            position.x = 0.1
        }
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        
        _cameraNode?.position = position
        
        SCNTransaction.commit()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - New in Part 5: Move Actions
    
    override func moveUp() {
        if _crashed {
            return
        }
        
        let oldDirection = self.upDownDirection
        
        super.moveUp()
        
        if oldDirection != self.upDownDirection {
            adjustCamera()
        }
    }
    
    // -------------------------------------------------------------------------
    
    override func moveDown() {
        let oldDirection = self.upDownDirection
        
        super.moveDown()

        if oldDirection != self.upDownDirection {
            adjustCamera()
        }
    }
    
    // -------------------------------------------------------------------------
    
    override func stopMovingUpDown() {
        if _crashed {
            return
        }

        let oldDirection = self.upDownDirection
        
        super.stopMovingUpDown()

        if oldDirection != self.upDownDirection {
            adjustCamera()
        }
    }
    
    // -------------------------------------------------------------------------
    
    override func moveLeft() {
        let oldDirection = self.leftRightDirection
        
        super.moveLeft()

        if oldDirection != self.leftRightDirection {
            adjustCamera()
        }
    }
    
    // -------------------------------------------------------------------------
    
    override func moveRight() {
        let oldDirection = self.leftRightDirection
        
        super.moveRight()
        
        if oldDirection != self.leftRightDirection {
            adjustCamera()
        }
    }
    
    // -------------------------------------------------------------------------
    
    override func stopMovingLeftRight() {
        let oldDirection = self.leftRightDirection
        
        super.stopMovingLeftRight()
        
        if oldDirection != self.leftRightDirection {
            adjustCamera()
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    override init() {
        super.init()
        
        // Set physics
        self.collissionNode!.name = "player"
        self.collissionNode!.physicsBody?.categoryBitMask = Game.Physics.Categories.player
        self.collissionNode!.physicsBody!.contactTestBitMask = Game.Physics.Categories.ring | Game.Physics.Categories.enemy

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
        
        self.state = .alive
        self.numberOfBullets = Game.Bullets.player
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}
