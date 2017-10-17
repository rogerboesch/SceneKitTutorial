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

    var _sceneView: SCNView?
    var _level: TutorialLevel2?
    
    // -------------------------------------------------------------------------
    // MARK: - Swipe gestures
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _level = TutorialLevel2()
        _level!.create()
        
        _sceneView = SCNView()
        _sceneView!.scene = _level
        _sceneView!.allowsCameraControl = false
        _sceneView!.showsStatistics = true
        _sceneView!.backgroundColor = UIColor.black
        //_sceneView!.debugOptions = .showWireframe
        self.view = _sceneView
        
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
