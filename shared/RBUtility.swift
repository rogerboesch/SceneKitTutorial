//
//  RBUtility.swift
//  General utilities
//
//  Created by Roger Boesch on 19/09/15.
//  Copyright © 2015 Roger Boesch. All rights reserved.
//

import Foundation
import CoreGraphics

internal let pi = CGFloat(Double.pi)

// -----------------------------------------------------------------------------
// MARK: - Deg/Rad

public func degreesToRadians(value: CGFloat) -> CGFloat {
    return value * pi / 180.0
}

// -----------------------------------------------------------------------------

public func radiansToDegrees(value: CGFloat) -> CGFloat {
    return value * 180.0 / pi
}

// -----------------------------------------------------------------------------

public typealias RunClosure = () -> ()

public class Run {
    
    public static func after(_ timeInterval: TimeInterval, _ closure: @escaping RunClosure) {
        let when = DispatchTime.now() + timeInterval
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
        }
    }
    
}

// -----------------------------------------------------------------------------
