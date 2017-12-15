//
//  GameViewController.swift
//
//  Created by Roger Boesch on 12/07/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//
//  Feel free to use this code in every way you want, but please consider also
//  to give esomething back to the community.
//
//  I don't own the license rights for the assets used in this tutorials
//  So before you use for something else then self-learning, please check by yourself the license behind
//  or even better replace it with your own art. Thank you!
//

import UIKit
import SceneKit

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
