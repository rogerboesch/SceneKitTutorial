//
//  GameSettings.swift
//
//  Part 4 of the SceneKit Tutorial Series 'From Zero to Hero' at:
//  https://rogerboesch.github.io/
//
//  Created by Roger Boesch on 12/10/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//
//  Structs are a very good way to structure the different application settings.
//  Like that they are easy to read and changeable at one place
//
//  New in Part 4: Move all constants here

import UIKit

struct Game {

    struct Player {
        static let moveOffset: CGFloat = 15
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
