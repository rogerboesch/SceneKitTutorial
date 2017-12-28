//
//  GameObject.swift
//
//  Part IV of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 31.10.17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//
//  New in part IV: This is a bigger change. While the game becomes more and more
//  various game objects, it's common to encapsulate general things
//  in a base class.
//  The most important is the state which is described in detail in the tutorial.

import SceneKit

enum GameObjecState {
    case initialized, alive, died, stopped
}

class GameObject : SCNNode {
    private static var count: Int = 0
    static var level: GameLevel?
    
    private var _internalID: Int = 0
    private var _tag = 0
    private var _state = GameObjecState.initialized
    
    // -------------------------------------------------------------------------
    // MARK: - Propertiues
    
    override var description: String {
        get {
            return "game object \(self.id)"
        }
    }
    
    // -------------------------------------------------------------------------
    
    var id: Int {
        return _internalID
    }
    
    // -------------------------------------------------------------------------
    
    var tag: Int {
        get {
            return _tag
        }
        set(value) {
            _tag = value
        }
    }

    // -------------------------------------------------------------------------
    
    var state: GameObjecState {
        get {
            return _state
        }
        set(value) {
            rbDebug("State of \(self) changed from \(_state) to \(value)")
            _state = value
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Actions
    
    func hit() {}       // Object get hit by another object

    // -------------------------------------------------------------------------

    func stop() {
         // Stop object (release all)
        self.state = .stopped
        stopAllActions(self)
    }

    // -------------------------------------------------------------------------
    // MARK: - Game loop
    
    func update(atTime time: TimeInterval, level: GameLevel) {}

    // -------------------------------------------------------------------------
    // MARK: - Collision handling
    
    func collision(with object: GameObject, level: GameLevel) {}
    
    // -------------------------------------------------------------------------
    // MARK: - Helper methods
    
    func stopAllActions(_ node: SCNNode) {
        // It's important to stop all actions before we remove a game object
        // Otherwise they continue to run and result in difficult side effects.
        node.removeAllActions()
        
        for child in node.childNodes {
            child.removeAllActions()
            stopAllActions(child)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation

    override init() {
        super.init()
        
        GameObject.count += 1
        _internalID = GameObject.count
    }
    
    // -------------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder aDecoder: NSCoder) is not implemented")
    }
    
    // -------------------------------------------------------------------------
}


