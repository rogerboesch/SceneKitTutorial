//
//  GameSettings.swift
//
//  Part VI of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/10/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//

import UIKit

struct Game {

    struct Points {
        static let ring: Int = 200                          // Points get when fly trough a ring
        static let enemy: Int = 100                         // Points get when shoot a enemy plane
        static let handicap: Int = 50                       // Points get when shoot a handicap
    }

    struct Bullets {
        static let player: Int = Int.max                    // Number of bullets player has initially
        static let enemy: Int = 1                           // Number of bullets an enemy plane has initially
    }

    struct Level {
        static let numberOfRings: Int = 10                  // Number of rings in level
        static let numberOfEnemies: Int = 20                // Number of enemy planes in level
        
        static let width: CGFloat = 640                     // Terrain width
        static let length: CGFloat = 960                    // Terraiun length
        static let start: CGFloat = 100                     // Start of player
        
        struct Fog {
            static let start: CGFloat = 20                  // Begin of fog
            static let end: CGFloat = 300                   // End of fog
        }
    }

    struct Plane {
        static let fireDistance: CGFloat = 70.0             // Fire distance (to player) for enemy

        static let actionTime: TimeInterval = 10.0          // Time used for move actions
        static let leftRightMoveDistance: CGFloat = 6.0     // Left/Right distance take in time
        static let upDownMoveDistance: CGFloat = 4.0        // Up/Down distance take in time
        static let speedDistance: CGFloat = 100.0           // Forward distance take in time

        static let upDownAngle: CGFloat = 5.0               // Angle when fly up or down
        static let leftRightAngle: CGFloat = 30.0           // Angle when fly left or right

        static let crashHeight: Float = 1.5                 // Minimum height when crashed
        static let minimumHeight: Float = 4.0               // Minimum height
        static let maximumHeight: Float = 30.0              // Maximum height
        static let maximumLeft: Float = 360.0               // Maximum left
        static let maximumRight: Float = 30.0               // Maximum right
    }
    
    struct Objects {
        static let offset: CGFloat = 15                     // Space between objects
    }

    struct Physics {
        
        // Category bits used for physics handling
        struct Categories {
            static let player: Int = 0b00000001
            static let ring:   Int = 0b00000010
            static let enemy:  Int = 0b00000100
            static let bullet: Int = 0b00001000
        }
    }

    struct Motion {
        static let threshold: Double = 0.2                  // Minium threshold of accelerometer
    }

}
