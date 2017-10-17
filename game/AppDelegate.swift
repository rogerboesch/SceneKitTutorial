//
//  AppDelegate.swift
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var _window: UIWindow?
    private var _gameViewController: GameViewController?
    
    // ------------------------------------------------------------------------------

    func applicationDidFinishLaunching(_ application: UIApplication) {
        _gameViewController = GameVi    ewController()
        
        _window = UIWindow(frame: UIScreen.main.bounds)
        _window?.rootViewController = _gameViewController
        _window?.makeKeyAndVisible()
    }

    // ------------------------------------------------------------------------------

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}

    // ------------------------------------------------------------------------------

}

