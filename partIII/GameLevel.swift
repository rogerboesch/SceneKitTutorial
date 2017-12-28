//
//  GameLevel.swift
//
//  Part 3 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/10/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//

import UIKit
import SceneKit

// -----------------------------------------------------------------------------

class GameLevel: SCNScene, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    private let levelWidth = 320
    private let levelLength = 640

    private var _terrain: RBTerrain?
    private var _player: Player?

    // Part 3: Number od rings and touched rings saved here
    private let numberOfRings = 10
    private var touchedRings = 0

    // Part 3: Reference to the HUD
    private var _hud: HUD?

    // -------------------------------------------------------------------------
    // MARK: - Properties

    var hud: HUD? {
        get {
            return _hud
        }
        set(value) {
            _hud = value
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Input handling
    
    func swipeLeft() {
        _player!.moveLeft()
    }

    // -------------------------------------------------------------------------

    func swipeRight() {
        _player!.moveRight()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Physics delegate

    func collision(withRing ring: Ring) {
        // Part 3: Collision handling based on physics
        if ring.isHidden {
            return
        }
 
        debugPrint("Collision width \(ring)")

        ring.isHidden = true
        _player!.roll()
        
        touchedRings += 1
        
        _hud?.points = touchedRings
    }

    // -------------------------------------------------------------------------

    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // Part 3: Physics delegate get called when objects collide
        if let ring = contact.nodeB.parent as? Ring {
            collision(withRing: ring)
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Place objects

    private func addRings() {
        // Part 3: Add rings to the game level
        let space = levelLength / (numberOfRings+1)
        
        for i in 1...numberOfRings {
            let ring = Ring()
            
            var x: CGFloat = 160
            let rnd = RBRandom.integer(1, 3)
            if rnd == 1 {
                x = x - Player.moveOffset
            }
            else if rnd == 3 {
                x = x + Player.moveOffset
            }
            
            ring.position = SCNVector3(Int(x), 3, (i*space))
            self.rootNode.addChildNode(ring)
        }
    }

    // -------------------------------------------------------------------------

    private func addPlayer() {
        _player = Player()
        _player!.position = SCNVector3(160, 4, 0)
        self.rootNode.addChildNode(_player!)
        
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: CGFloat(levelLength)-10, duration: 60)
        _player!.runAction(moveAction)
    }
    
    // -------------------------------------------------------------------------
    
    private func addTerrain() {
        // Create terrain
        _terrain = RBTerrain(width: levelWidth, length: levelLength, scale: 128)
        
        let generator = RBPerlinNoiseGenerator(seed: nil)
        _terrain?.formula = {(x: Int32, y: Int32) in
            return generator.valueFor(x: x, y: y)
        }
        
        _terrain!.create(withColor: UIColor.green)
        _terrain!.position = SCNVector3Make(0, 0, 0)
        self.rootNode.addChildNode(_terrain!)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    func create() {
        addTerrain()
        addPlayer()
        addRings()
    }
    
    // -------------------------------------------------------------------------
    
    override init() {
        super.init()
        
        self.physicsWorld.contactDelegate = self
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}
