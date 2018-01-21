//
//  GameSettings.swift
//
//  Part 3 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/10/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//
//  Structs are a very good way to structure the different application settings.
//  Like that they are easy to read and changeable at one place
//

import Foundation
import RBSceneUIKit

struct Game {
    
    struct Physics {
        
        // Category bits used for physics handling
        struct Categories {
            static let player: Int = 0b00000001
            static let ring: Int = 0b00000010
        }
        
    }
}
