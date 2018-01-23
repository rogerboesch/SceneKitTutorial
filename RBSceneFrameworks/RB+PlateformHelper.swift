//
//  RB+PlateformHelper.swift
//  frameworks
//
//  Created by Denis Martin on 21/01/2018.
//  Copyright © 2018 Roger Boesch. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
    public typealias RBColor = NSColor
    public typealias RBImage = NSImage
    public typealias RBFloat = CGFloat
    
#else
    import UIKit
    public typealias RBColor = UIColor
    public typealias RBImage = UIImage
    public typealias RBFloat = Float
    
#endif
