//
//  HUD.swift
//
//  Part 3 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 11.11.17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//
//  This class I have newly introduced in Part 3. It's purpose
//  is to show information, like points, time etc. to the user.
//  At the moment the number of catched rings.
//

import SpriteKit
import RBSceneUIKit

class HUD {
    private var _scene: SKScene!
    private let _points = SKLabelNode(text: "0 RINGS")
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var scene: SKScene {
        get {
            return _scene
        }
    }

    // -------------------------------------------------------------------------

    var points: Int {
        get {
            return 0
        }
        set(value) {
            _points.text = String(format: "%d RINGS", value)
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(size: CGSize) {
        _scene = SKScene(size: size)
    
        _points.position = CGPoint(x: size.width/2, y: size.height-50)
        _points.horizontalAlignmentMode = .center
        _points.fontName = "MarkerFelt-Wide"
        _points.fontSize = 30
        _points.fontColor = UIColor.white
        _scene.addChild(_points)
    }
    
    // -------------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not implemented")
    }
    
    // -------------------------------------------------------------------------
}

