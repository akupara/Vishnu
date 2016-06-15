//
//  UIColor+LerpExtension.swift
//  Vishnu
//
//  Created by Daniel Lu on 6/15/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import UIKit

extension UIColor {
    private struct Utility {
        static func lerp(start start: CGFloat, end: CGFloat, faction: CGFloat) -> CGFloat{
            return faction * (end - start) + start
        }
    }
    
    public class func colorInRGBLerpFrom(start start: UIColor, to end:UIColor, withFraction fraction: CGFloat) -> UIColor {
        let clampedFaction  = max(0.0, min(1.0, fraction))
        
        let zero:CGFloat = 0.0
        var (red1, green1, blue1, alpha1) = (zero, zero, zero, zero)
        start.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        
        var (red2, green2, blue2, alpha2) = (zero, zero, zero, zero)
        end.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        let r:CGFloat = Utility.lerp(start: red1, end: red2, faction: clampedFaction)
        let g:CGFloat = Utility.lerp(start: green1, end: green2, faction: clampedFaction)
        let b:CGFloat = Utility.lerp(start: blue1, end: blue2, faction: clampedFaction)
        let a:CGFloat = Utility.lerp(start: alpha1, end: alpha2, faction: clampedFaction)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    public class func colorInHSVFrom(start start:UIColor, to end:UIColor, withFaction faction:CGFloat) -> UIColor {
        let clampedFaction = max(0, min(1, faction))
        
        let zero:CGFloat = 0.0
        
        var (h1, s1, b1, a1) = (zero, zero, zero, zero)
        start.getHue(&h1, saturation: &s1, brightness: &b1, alpha: &a1)
        
        var (h2, s2, b2, a2) = (zero, zero, zero, zero)
        end.getHue(&h2, saturation: &s2, brightness: &b2, alpha: &a2)
        
        let h:CGFloat = Utility.lerp(start: h1, end: h2, faction: clampedFaction)
        let s:CGFloat = Utility.lerp(start: s1, end: s2, faction: clampedFaction)
        let b:CGFloat = Utility.lerp(start: b1, end: b2, faction: clampedFaction)
        let a:CGFloat = Utility.lerp(start: a1, end: a2, faction: clampedFaction)
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
}
