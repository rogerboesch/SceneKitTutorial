//
//  GameLevel.swift
//
//  Part 4 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/10/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//
//  New in Part 4:
//  The game has become a game loop. A main concept used in any pro game
//  While you can create SceneKit games without this, it open's some b iug
//  advantages which are covered in more detail in the tutorial

import UIKit
import SceneKit
import RBSceneUIKit

enum GameState {
    case initialized, play, win, loose, stopped
}

// -----------------------------------------------------------------------------

class GameLevel: SCNScene, SCNPhysicsContactDelegate {
    private let levelWidth = 320
    private let levelLength = 640

    // New in Part 4: A list of all game objects
    private var _gameObjects = Array<GameObject>()

    private var _terrain: RBTerrain?
    private var _player: Player?
    private var _hud: HUD?

    private let _numberOfRings = 10
    private var _touchedRings = 0
    
    // New in Part 4: We catch now also the number of missed rings
    private var _missedRings = 0

    // New in Part 4: The game becomes differenr states
    private var _state = GameState.initialized

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
    
    var state: GameState {
        get {
            return _state
        }
        set(value) {
            rbDebug("State of level changed from \(_state) to \(value)")
            _state = value
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
    // MARK: - Actions
    
    func flyTrough(_ ring: Ring) {
        _touchedRings += 1
        _hud?.rings = _touchedRings
    }

    // -------------------------------------------------------------------------

    func touchedHandicap(_ handicap: Handicap) {
        _hud?.message("GAME OVER", information: "- Touch to restart - ")

        self.state = .loose
    }

    // -------------------------------------------------------------------------
    // MARK: - Game loop
    
    func update(atTime time: TimeInterval) {
        // New in Part 4: The game loop (see tutorial)
        if self.state != .play {
            return
        }
        
        var missedRings = 0
        
        for object in _gameObjects {
            object.update(atTime: time, level: self)

            // Check which rings are behind the player but still 'alive'
            if let ring = object as? Ring {
                if (ring.presentation.position.z + 5.0) < _player!.presentation.position.z {
                    if ring.state == .alive {
                        missedRings += 1
                    }
                }
            }
        }
        
        if missedRings > _missedRings {
            _missedRings = missedRings
            _hud?.missedRings = _missedRings
        }
        
        // Test for end of game
        if _missedRings + _touchedRings == _numberOfRings {
            if _missedRings < 3 {
                _hud?.message("YOU WIN", information: "- Touch to restart - ")
            }
            else {
                _hud?.message("TRY TO IMPROVE", information: "- Touch to restart - ")
            }

            self.state = .win
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Physics delegate

    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // Part 4: Call collision handler of the object (see GameObject)
        if let gameObjectA = contact.nodeA.parent as? GameObject, let gameObjectB = contact.nodeB.parent as? GameObject {
            gameObjectA.collision(with: gameObjectB, level: self)
            gameObjectB.collision(with: gameObjectA, level: self)
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Place objects

    private func addRings() {
        // Part 3: Add rings to the game level
        let space = levelLength / (_numberOfRings+1)
        
        for i in 1..._numberOfRings {
            let ring = Ring()
            
            var x: CGFloat = 160
            let rnd = RBRandom.integer(1, 3)
            if rnd == 1 {
                x = x - Game.Player.moveOffset
            }
            else if rnd == 3 {
                x = x + Game.Player.moveOffset
            }
            
            ring.position = SCNVector3(Int(x), 3, (i*space))
            self.rootNode.addChildNode(ring)
            
            _gameObjects.append(ring)
        }
    }

    // -------------------------------------------------------------------------

    private func addHandicap(x: CGFloat, z: CGFloat) {
        let handicap = Handicap()
        handicap.position = SCNVector3(x, handicap.height/2, z)
        self.rootNode.addChildNode(handicap)
        
        _gameObjects.append(handicap)
    }

    // -------------------------------------------------------------------------

    private func addHandicaps() {
        // Part 4: Add handicaps to the game level
        let space: CGFloat = CGFloat(levelLength / (_numberOfRings+1))
        
        for i in 1..._numberOfRings-1 {
            var x: CGFloat = 160
            let rnd = RBRandom.integer(1, 3)
            
            if rnd == 1 {
                x = x - Game.Player.moveOffset
                
                addHandicap(x: x-RBRandom.cgFloat(10, 50), z: CGFloat(i)*space + space/2.0)
                addHandicap(x: x+Game.Player.moveOffset+RBRandom.cgFloat(10, 50), z: CGFloat(i)*space + space/2.0)
            }
            else if rnd == 3 {
                x = x + Game.Player.moveOffset
                
                addHandicap(x: x+RBRandom.cgFloat(10, 50), z: CGFloat(i)*space + space/2.0)
                addHandicap(x: x-Game.Player.moveOffset-RBRandom.cgFloat(10, 50), z: CGFloat(i)*space + space/2.0)
            }
            
            addHandicap(x: x, z: CGFloat(i)*space + space/2.0)
        }
    }

    // -------------------------------------------------------------------------

    private func addPlayer() {
        _player = Player()
        _player!.state = .alive
        
        _player!.position = SCNVector3(160, 4, 0)
        self.rootNode.addChildNode(_player!)
        
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: CGFloat(levelLength)-10, duration: 60)
        _player!.runAction(moveAction)

        _gameObjects.append(_player!)
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
    // MARK: - Stop
    
    func stop() {
        // New in Part 4: Stop all!
        for object in _gameObjects {
            object.stop()
        }
        
        self.physicsWorld.contactDelegate = nil
        self.hud = nil
        self.state = .stopped
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation

    func create() {
        // New in Part 4: A skybox is used to show a game's background
        self.background.contents = #imageLiteral(resourceName: "skybox")

        addTerrain()
        addRings()
        addHandicaps()
        addPlayer()
        
        self.state = .play
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
