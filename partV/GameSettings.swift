//
//  GameSettings.swift
//
//  Part III of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/10/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//
//  Structs are a very good way to structure the different application settings.
//  Like that they are easy to read and changeable at one place
//
//  New in part IV: Move all constants here

import UIKit

struct Game {

    struct Player {
        static var actionTime: TimeInterval = 10.0          // Time used for move actions
        static let leftRightMoveDistance: CGFloat = 6.0     // Left/Right distance take in time
        static let upDownMoveDistance: CGFloat = 4.0        // Up/Down distance take in time
        static let speedDistance: CGFloat = 100.0           // Forward distance take in time

        static let upDownAngle: CGFloat = 5.0               // Angle when fly up or down
        static let leftRightAngle: CGFloat = 30.0           // Angle when fly left or right

        static let minimumHeight: Float = 3.0               // Minimum height
        static let maximumHeight: Float = 30.0              // Maximum height
        static let maximumLeft: Float = 360.0               // Maximum left
        static let maximumRight: Float = 30.0               // Maximum right
    }
    
    struct Objects {
        static let offset: CGFloat = 15
    }

    struct Physics {
        
        // Category bits used for physics handling
        struct Categories {
            static let player: Int = 0b00000001
            static let ring:   Int = 0b00000010
            static let enemy:  Int = 0b00000100
        }
        
    }
}
