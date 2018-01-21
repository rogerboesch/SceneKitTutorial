//
//  GameViewController.swift
//
//  Part 1 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/07/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//

import UIKit
import SceneKit
import RBSceneUIKit

class GameViewController: UIViewController {

    private var _sceneView: SCNView!
    private var _level: GameLevel!
   
    // -------------------------------------------------------------------------
    // MARK: - ViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _level = GameLevel()
        _level.create()
        
        _sceneView = SCNView()
        _sceneView.scene = _level
        _sceneView.allowsCameraControl = false
        _sceneView.showsStatistics = true
        _sceneView.backgroundColor = UIColor.black
        _sceneView!.debugOptions = .showWireframe
        self.view = _sceneView
    }

    // -------------------------------------------------------------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // -------------------------------------------------------------------------

}
