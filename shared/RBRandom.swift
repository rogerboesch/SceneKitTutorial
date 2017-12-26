//
//  RBRandom.swift
//  Random number extensions
//
//  Created by Roger Boesch on 13/01/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//
//  This class I have newly introduced in part III. It's mainly and abstraction
//  class for the classes and methods available in GameKit. It allows a better
// random handling then those available in system library.

import Foundation
import GameKit

extension Int {
    static func random(maxValue: Int) -> Int {
        let rand = Int(arc4random_uniform(UInt32(maxValue)))
        return rand
    }
}

class RBRandom {
    private let source = GKMersenneTwisterRandomSource()
    
    // -------------------------------------------------------------------------
    // MARK: - Get random numbers
    
    class func boolean() -> Bool {
        if RBRandom.sharedInstance.integer(0, 1) == 1 {
            return true
        }
        
        return false
    }

    // -------------------------------------------------------------------------

    class func integer(_ from: Int, _ to: Int) -> Int {
        return RBRandom.sharedInstance.integer(from, to)
    }

    // -------------------------------------------------------------------------
    
    class func timeInterval(_ from: Int, _ to: Int) -> TimeInterval {
        return TimeInterval(RBRandom.sharedInstance.integer(from, to))
    }
    
    // -------------------------------------------------------------------------
    
    class func cgFloat(_ from: CGFloat, _ to: CGFloat) -> CGFloat {
        return CGFloat(RBRandom.sharedInstance.integer(Int(from), Int(to)))
    }
    
    // -------------------------------------------------------------------------
    
    private func integer(_ from: Int, _ to: Int) -> Int {
        let rd = GKRandomDistribution(randomSource: self.source, lowestValue: from, highestValue: to)
        let number = rd.nextInt()
        
        return number
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init() {
        source.seed = UInt64(CFAbsoluteTimeGetCurrent())
    }
    
    // -------------------------------------------------------------------------
    
    private static let sharedInstance : RBRandom = {
        let instance = RBRandom()
        return instance
    }()
    
    // -------------------------------------------------------------------------

}

