//
//  RBUtility.swift
//  General utilities
//
//  Created by Roger Boesch on 19/09/15.
//  Copyright © 2015 Roger Boesch. All rights reserved.
//

import UIKit

let pi = CGFloat(Double.pi)

// -----------------------------------------------------------------------------
// MARK: - Deg/Rad

func degreesToRadians(value: CGFloat) -> CGFloat {
    return value * pi / 180.0
}

// -----------------------------------------------------------------------------

func radiansToDegrees(value: CGFloat) -> CGFloat {
    return value * 180.0 / pi
}

// -----------------------------------------------------------------------------

typealias RunClosure = () -> ()

public class Run {
    
    static func after(_ timeInterval: TimeInterval, _ closure: @escaping RunClosure) {
        let when = DispatchTime.now() + timeInterval
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
        }
    }
    
}

// -----------------------------------------------------------------------------
