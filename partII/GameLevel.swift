//
//  GameLevel.swift
//
//  Part 2 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/10/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//

import UIKit
import SceneKit
import RBSceneUIKit

// -----------------------------------------------------------------------------

class GameLevel: SCNScene, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    private let levelWidth = 320
    private let levelLength = 320
    
    private var _terrain: RBTerrain?
    private var _player: Player?
    
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
    // MARK: - Place objects
    
    private func addPlayer() {
        _player = Player()
        _player!.position = SCNVector3(160, 3, 0)
        self.rootNode.addChildNode(_player!)
        
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 200, duration: 20)
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
        
        _terrain!.create(withImage: #imageLiteral(resourceName: "grass"))
        _terrain!.position = SCNVector3Make(0, 0, 0)
        self.rootNode.addChildNode(_terrain!)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    func create() {
        addTerrain()
        addPlayer()
    }
    
    // -------------------------------------------------------------------------
    
    override init() {
        super.init()
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}
