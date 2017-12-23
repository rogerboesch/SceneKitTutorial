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
