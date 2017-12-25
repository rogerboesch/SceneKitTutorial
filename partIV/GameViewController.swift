//
//  GameViewController.swift
//
//  Part III of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/07/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    private var _sceneView: SCNView!
    private var _level: GameLevel!
    private var _hud: HUD!
    
    // -------------------------------------------------------------------------
    // MARK: - Properties

    var sceneView: SCNView {
        return _sceneView
    }

    // -------------------------------------------------------------------------

    var hud: HUD {
        return _hud
    }

    // -------------------------------------------------------------------------
    // MARK: - Render delegate (New in Part IV)
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        if _level != nil {
            _level.update(atTime: time)
        }

        renderer.loops = true
    }

    // -------------------------------------------------------------------------
    // MARK: - Gesture recognoizers
    
    @objc private func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
        // New in part IV: A tap is used to restart the level (see tutorial)
        if _level.state == .loose || _level.state == .win {
            _level.stop()
            _level = nil
            
            DispatchQueue.main.async {
                // Create things in main thread
                
                let level = GameLevel()
                level.create()
                
                level.hud = self.hud
                self.hud.reset()
                
                self.sceneView.scene = level
                self._level = level
            }

        }
    }

    // -------------------------------------------------------------------------

    @objc private func handleSwipe(_ gestureRecognize: UISwipeGestureRecognizer) {
        if (gestureRecognize.direction == .left) {
            _level!.swipeLeft()
        }
        else if (gestureRecognize.direction == .right) {
            _level!.swipeRight()
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - ViewController life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Part III: HUD is created and assigned to view and game level
        _hud = HUD(size: self.view.bounds.size)
        _level.hud = _hud
        _sceneView.overlaySKScene = _hud.scene
    }

    // -------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _level = GameLevel()
        _level.create()
        
        _sceneView = SCNView()
        _sceneView.scene = _level
        _sceneView.allowsCameraControl = false
        _sceneView.showsStatistics = true
        _sceneView.backgroundColor = UIColor.black
        _sceneView.delegate = self

        self.view = _sceneView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        _sceneView!.addGestureRecognizer(tapGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeftGesture.direction = .left
        _sceneView!.addGestureRecognizer(swipeLeftGesture)

        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRightGesture.direction = .right
        _sceneView!.addGestureRecognizer(swipeRightGesture)
    }

    // -------------------------------------------------------------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // -------------------------------------------------------------------------

}
