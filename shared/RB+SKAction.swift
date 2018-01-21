//
//  SKAction+Extensions.swift
//  SpriteKit action extensions
//
//  Created by Roger Boesch on 19/09/13.
//  Copyright © 2015 Roger Boesch. All rights reserved.
//

import SpriteKit

// -----------------------------------------------------------------------------
// MARK: - Timing functions

public func SKTTimingFunctionLinear(_ t: CGFloat) -> CGFloat {
    return t
}

public func SKTCreateShakeFunction(_ oscillations: Int) -> (CGFloat) -> CGFloat {
    return { t in -pow(2.0, -10.0 * t) * sin(t * pi * CGFloat(oscillations) * 2.0) + 1.0 }
}

// -----------------------------------------------------------------------------
// MARK: - Effects

public class SKTEffect {
    
    unowned var node: SKNode
    public var duration: TimeInterval
    open var timingFunction: ((CGFloat) -> CGFloat)?

    init(node: SKNode, duration: TimeInterval) {
        self.node = node
        self.duration = duration
        
        timingFunction = SKTTimingFunctionLinear
    }

    func update(_ t: CGFloat) { }
}

public class SKTScaleEffect: SKTEffect {
    var startScale: CGPoint
    var delta: CGPoint
    var previousScale: CGPoint
    
    init(node: SKNode, duration: TimeInterval, startScale: CGPoint, endScale: CGPoint) {
        previousScale = CGPoint(x: node.xScale, y: node.yScale)
        self.startScale = startScale
        delta = endScale - startScale
        
        super.init(node: node, duration: duration)
    }
    
    override func update(_ t: CGFloat) {
        let newScale = startScale + delta*t
        let diff = newScale / previousScale
        previousScale = newScale
        node.xScale *= diff.x
        node.yScale *= diff.y
    }
}

// -----------------------------------------------------------------------------
// MARK: - Actions

public extension SKAction {
    
    public class func actionWithEffect(_ effect: SKTEffect) -> SKAction {
        return SKAction.customAction(withDuration: effect.duration) { node, elapsedTime in
            var t = elapsedTime / CGFloat(effect.duration)
            
            if let timingFunction = effect.timingFunction {
                t = timingFunction(t)
            }
            
            effect.update(t)
        }
    }

    
    public class func zoomWithNode(_ node: SKNode, amount: CGPoint, oscillations: Int, duration: TimeInterval) -> SKAction {
        let oldScale = CGPoint(x: node.xScale, y: node.yScale)
        let newScale = oldScale * amount
        
        let effect = SKTScaleEffect(node: node, duration: duration, startScale: newScale, endScale: oldScale)
        effect.timingFunction = SKTCreateShakeFunction(oscillations)
        
        return SKAction.actionWithEffect(effect)
    }

    // -------------------------------------------------------------------------

}
