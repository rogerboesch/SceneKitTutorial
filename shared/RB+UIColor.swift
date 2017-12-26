//
//  RB+UIColor.swift
//  UIColor extensions
//
//  Created by Roger Boesch on 01/11/15.
//  Copyright © 2016 Roger Boesch All rights reserved.
//

import SceneKit

// -----------------------------------------------------------------------------

let UIRedColorList:[UIColor] = [
    UIColor(hex: "#800000"),
    UIColor(hex: "#AA0000"),
    UIColor(hex: "#D40000"),
    UIColor(hex: "#FF0000"),
    UIColor(hex: "#FF2A2A")
]

// -----------------------------------------------------------------------------

let UIPurpleColorList:[UIColor] = [
    UIColor(hex: "#660067"),
    UIColor(hex: "#810080"),
    UIColor(hex: "#BE2AED"),
    UIColor(hex: "#D997FF"),
    UIColor(hex: "#F0BCFF")
]

// -----------------------------------------------------------------------------

let UINeonColorList:[UIColor] = [
    UIColor(hex: "#FF15AC"),
    UIColor(hex: "#FF6900"),
    UIColor(hex: "#FFFF01"),
    UIColor(hex: "#00FF01"),
    UIColor(hex: "#01E6f0")
]

// -----------------------------------------------------------------------------

let UIGreenColorList:[UIColor] = [
    UIColor(hex: "#075907"),
    UIColor(hex: "#097609"),
    UIColor(hex: "#70AF1A"),
    UIColor(hex: "#B9D40B"),
    UIColor(hex: "#E5EB0B")
]

// -----------------------------------------------------------------------------

let UIGrayColorList:[UIColor] = [
    UIColor(hex: "#C0CBCB"),
    UIColor(hex: "#CAC6BF"),
    UIColor(hex: "#B4ACA1"),
    UIColor(hex: "#E5E4dE"),
    UIColor(hex: "#C5C1B7"),
    UIColor(hex: "#78797D")
]

// -----------------------------------------------------------------------------
// MARK: - Hex support

extension UIColor {
    
    public convenience init(hex: String) {
        var str = hex
        
        if str.hasPrefix("#") {
            let index = str.index(str.startIndex, offsetBy: 1)
            str = String(str[index...])
        }
        
        if (str.count == 6) {
            str = "\(str)ff"
        }
        
        if str.count  == 8 {
            let scanner = Scanner(string: String(str))
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                let r = (hexNumber & 0xff000000) >> 24
                let g = (hexNumber & 0x00ff0000) >> 16
                let b = (hexNumber & 0x0000ff00) >> 8
                let a = (hexNumber & 0x000000ff)
                
                self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
                return
            }
        }
        
        self.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
}

// -----------------------------------------------------------------------------
// MARK: - Random colors

extension UIColor {
    
    public static func random(list: [UIColor]) -> UIColor {
        let maxValue = list.count
        let rand = RBRandom.integer(0, maxValue-1)
        
        return list[rand]
    }
    
}
