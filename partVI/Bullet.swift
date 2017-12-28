//
//  Bullet.swift
//
//  Part 6 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 13/12/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import UIKit
import SceneKit

class Bullet : GameObject {
    private static let speedDistance: CGFloat = 80.0    // Distance taken in time
    private static let lifeTime: TimeInterval = 3.0     // Life time of a bullet in s
    
    private var _enemy = false                          // Bullet show by player/enemy
    private var _speed: CGFloat = 2.0                   // Speed of th ebullet
    
    private var _bulletNode: SCNNode!
    
    // -------------------------------------------------------------------------
    // MARK: - Getter/Setter
    
    var enemy: Bool {
        get {
            return _enemy
        }
        set(value) {
            _enemy = value
            
            if (_enemy) {
                _bulletNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
                _bulletNode.physicsBody!.categoryBitMask = Game.Physics.Categories.bullet
                _bulletNode.physicsBody!.contactTestBitMask = Game.Physics.Categories.player
            }
            else {
                _bulletNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
                _bulletNode.physicsBody!.categoryBitMask = Game.Physics.Categories.bullet
                _bulletNode.physicsBody!.contactTestBitMask = Game.Physics.Categories.enemy
            }
        }
    }
    
    // -------------------------------------------------------------------------

    override var description: String {
        get {
            if (self.enemy) {
                return "enemy bullet \(self.id)"
            }
            else {
                return "player bullet \(self.id)"
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Fire bullet
    
    func fire(direction: PlaneDirection, sideDistance: CGFloat, fallDistance: CGFloat, speed: CGFloat = 2.0) {
        var moveAction: SCNAction?
        
        self.state = .alive
        
        _speed = speed
        
        switch (direction) {
        case .up:
            moveAction = SCNAction.moveBy(x: sideDistance, y: fallDistance, z: Bullet.speedDistance, duration: TimeInterval(10/_speed))
        case .down:
            moveAction = SCNAction.moveBy(x: -sideDistance, y: fallDistance, z: -Bullet.speedDistance, duration: TimeInterval(10/_speed))
        case .left:
            moveAction = SCNAction.moveBy(x: Bullet.speedDistance, y: fallDistance, z: 0, duration: TimeInterval(10/_speed))
        case .right:
            moveAction = SCNAction.moveBy(x: -Bullet.speedDistance, y: fallDistance, z: 0, duration: TimeInterval(10/_speed))
            
        default:
            return
        }
        
        self.runAction(SCNAction.repeatForever(moveAction!), forKey: "fire")
        
        let delay = SCNAction.wait(duration: Bullet.lifeTime)
        let action2 = SCNAction.run({ _ in
            rbDebug("Lifetime is over for \(self)")
            
            self.isHidden = true
            self.state = .died
            self.removeAllActions()
        })
        
        self.runAction(SCNAction.sequence([delay, action2]), forKey: "lifetime")
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Collision handling

    override func collision(with object: GameObject, level: GameLevel) {
        // Collision with player and enemies are handled in their classes
        // Here the bullets are set themself to destroyed
        if (self.state == .died) {
            return
        }
        
        if let enemy = object as? Enemy {
            // Check for player bullet
            if !self.enemy {
                rbDebug("\(self) collided with \(object)")

                GameSound.explosion(enemy)
                enemy.hit()
                
                level.addPoints(enemy.points)

            }
        }
        else if let player = object as? Player {
            // Check for enemy bullet
            if self.enemy {
                rbDebug("\(self) collided with \(object)")

                GameSound.explosion(player)
                player.hit()
            }
        }
        else if let handicap = object as? Handicap {
            // Check for player bullet
            if !self.enemy {
                rbDebug("\(self) collided with \(object)")

                GameSound.explosion(handicap)
                handicap.hit()

                level.addPoints(handicap.points)
            }
        }

        // Destroy myself
        self.isHidden = true
        self.state = .died
        
        self.removeAllActions()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(enemy: Bool) {
        super.init()
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        let geometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.0)

        _bulletNode = SCNNode(geometry: geometry)

        self.addChildNode(_bulletNode)
        
        self.enemy = enemy
        
        rbDebug("Create \(self)")
    }
    
    // -------------------------------------------------------------------------
    
    required init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // -------------------------------------------------------------------------
    
}

