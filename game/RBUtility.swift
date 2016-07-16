//
//  RBUtility.swift
//
//  General utilities
//
//  Created by Roger Boesch on 19/09/15.
//  Copyright © 2015 Roger Boesch. All rights reserved.
//
//  Feel free to use this code in every way you want, but please consider also
//  to give esomething back to the community.
//
//  I don't own the license rights for the assets used in this tutorials
//  So before you use for something else then self-learning, please check by yourself the license behind
//  or even better replace it with your own art. Thank you!
//

import UIKit

let pi = CGFloat(M_PI)

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
