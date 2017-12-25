//
//  HUD.swift
//
//  Part III of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 11.11.17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import SpriteKit

class HUD {
    private var _scene: SKScene!
    private let _rings = SKLabelNode(text: "")
    private let _missedRings = SKLabelNode(text: "")
    private let _message = SKLabelNode(text: "")
    private let _info = SKLabelNode(text: "")

    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var scene: SKScene {
        get {
            return _scene
        }
    }

    // -------------------------------------------------------------------------
    
    var rings: Int {
        get {
            return 0
        }
        set(value) {
            if value == 1 {
                _rings.text = String(format: "%d RING", value)
            }
            else {
                _rings.text = String(format: "%d RINGS", value)
            }
            
            // New in part IV: Animated HUD informations (check RB+SKAction.swift for details)
            let scaling: CGFloat = 3
            let action = SKAction.zoomWithNode(_rings, amount: CGPoint.make(scaling, scaling), oscillations: 1, duration: 0.5)
            _rings.run(action)
        }
    }

    // -------------------------------------------------------------------------
    
    var missedRings: Int {
        get {
            return 0
        }
        set(value) {
            _missedRings.text = String(format: "%d MISSED", value)
            
            if value > 0 {
                _missedRings.fontColor = UIColor.red
            }
            else {
                _missedRings.fontColor = UIColor.white
            }

            let scaling: CGFloat = 3
            let action = SKAction.zoomWithNode(_missedRings, amount: CGPoint.make(scaling, scaling), oscillations: 1, duration: 0.5)
            _missedRings.run(action)
        }
    }

    // -------------------------------------------------------------------------
    
    func message(_ str: String, information: String? = nil) {
        // New in part IV: Used for game over and win messages
        _message.text = str
        _message.isHidden = false
        
        let scaling: CGFloat = 10
        let action = SKAction.zoomWithNode(_message, amount: CGPoint.make(scaling, scaling), oscillations: 1, duration: 0.5)
        _message.run(action)
        
        if information != nil {
            info(information!)
        }
    }

    // -------------------------------------------------------------------------
    
    func info(_ str: String) {
        // New in part IV: Uses for additional info when show messages

        _info.text = str
        _info.isHidden = false
        
        let scaling: CGFloat = 2
        let action = SKAction.zoomWithNode(_info, amount: CGPoint.make(scaling, scaling), oscillations: 1, duration: 0.5)
        _info.run(action)
    }

    // -------------------------------------------------------------------------

    func reset() {
        // New in part IV: Reset is needed whenever start the level

        _message.text = ""
        _message.isHidden = true

        _info.text = ""
        _info.isHidden = true

        _rings.text = "0 RINGS"
        _missedRings.text = "0 MISSED"
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(size: CGSize) {
        _scene = SKScene(size: size)
        
        _rings.position = CGPoint(x: 40, y: size.height-50)
        _rings.horizontalAlignmentMode = .left
        _rings.fontName = "MarkerFelt-Wide"
        _rings.fontSize = 30
        _rings.fontColor = UIColor.white
        _scene.addChild(_rings)
        
        _missedRings.position = CGPoint(x: size.width-40, y: size.height-50)
        _missedRings.horizontalAlignmentMode = .right
        _missedRings.fontName = "MarkerFelt-Wide"
        _missedRings.fontSize = 30
        _missedRings.fontColor = UIColor.white
        _scene.addChild(_missedRings)
        
        _message.position = CGPoint(x: size.width/2, y: size.height/2)
        _message.horizontalAlignmentMode = .center
        _message.fontName = "MarkerFelt-Wide"
        _message.fontSize = 60
        _message.fontColor = UIColor.white
        _message.isHidden = true
        _scene.addChild(_message)
        
        _info.position = CGPoint(x: size.width/2, y: size.height/2-40)
        _info.horizontalAlignmentMode = .center
        _info.fontName = "MarkerFelt-Wide"
        _info.fontSize = 20
        _info.fontColor = UIColor.white
        _info.isHidden = true
        _scene.addChild(_info)

        reset()
    }
    
    // -------------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not implemented")
    }
    
    // -------------------------------------------------------------------------
}
