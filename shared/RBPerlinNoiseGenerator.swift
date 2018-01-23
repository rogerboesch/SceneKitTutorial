//
//  RBPerlinNoiseGenerator.swift
//  Perlin noise generator (used for terrain class)
//
//  Created by Roger Boesch on 12/07/16.
//  Based on Obj-C code created by Steven Troughton-Smith on 24/12/11.
//

import Foundation

public class RBPerlinNoiseGenerator {
    
    private static let noiseX = 1619
    private static let noiseY = 31337
    private static let noiseSeed = 1013
    
    private var _seed: Int = 1
    
    // -------------------------------------------------------------------------

    private func interpolate(a: Double, b: Double, x: Double) ->Double {
        let ft: Double = x * Double.pi
        let f: Double = (1.0-cos(ft)) * 0.5
        
        return a*(1.0-f)+b*f
    }

    // -------------------------------------------------------------------------

    private func findNoise(x: Double, y: Double) ->Double {
        var n = (RBPerlinNoiseGenerator.noiseX*Int(x) +
                 RBPerlinNoiseGenerator.noiseY*Int(y) +
                 RBPerlinNoiseGenerator.noiseSeed * _seed) & 0x7fffffff
        
        n = (n >> 13) ^ n
        n = (n &* (n &* n &* 60493 + 19990303) + 1376312589) & 0x7fffffff
        
        return 1.0 - Double(n)/1073741824
    }

    // -------------------------------------------------------------------------

    private func noise(x: Double, y: Double) ->Double {
        let floorX: Double = Double(Int(x))
        let floorY: Double = Double(Int(y))
        
        let s = findNoise(x:floorX, y:floorY)
        let t = findNoise(x:floorX+1, y:floorY)
        let u = findNoise(x:floorX, y:floorY+1)
        let v = findNoise(x:floorX+1, y:floorY+1)
        
        let i1 = interpolate(a:s, b:t, x:x-floorX)
        let i2 = interpolate(a:u, b:v, x:x-floorX)
        
        return interpolate(a:i1, b:i2, x:y-floorY)
    }
 
    // -------------------------------------------------------------------------
    // MARK: - Calculate a noise value for x,y

    public func valueFor(x: Int32, y: Int32) ->Double {
        let octaves = 2
        let p: Double = 1/2
        let zoom: Double = 6
        var getnoise: Double = 0
        
        for a in 0..<octaves-1 {
            let frequency = pow(2, Double(a))
            let amplitude = pow(p, Double(a))
            
            getnoise += noise(x:(Double(x))*frequency/zoom, y:(Double(y))/zoom*frequency)*amplitude
        }
        
        var value: Double = Double(((getnoise*128.0)+128.0))
        
        if (value > 255) {
            value = 255
        }
        else if (value < 0) {
            value = 0
        }
        
        return value
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation

    public init(seed: Int? = nil) {
        if let seed = seed {
            _seed = seed
        } else {
            _seed = Int(arc4random()) % Int(INT32_MAX)
        }
    }

    // -------------------------------------------------------------------------

}
