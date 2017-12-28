//
//  RB+SCNVector.swift
//  SCNVector3 extension
//
//  Created by Roger Boesch on 1/09/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import SceneKit

extension SCNVector3 {

    func distance(to destination: SCNVector3) -> CGFloat {
        let dx = destination.x - x
        let dy = destination.y - y
        let dz = destination.z - z
        
        return CGFloat(sqrt(dx*dx + dy*dy + dz*dz))
    }

}
