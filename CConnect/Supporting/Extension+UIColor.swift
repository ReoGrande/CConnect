//
//  Extension+UIColor.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/6/25.
//

import UIKit
import SwiftUI

extension Color {

    init?(hexString: String) {

        let rgbaData = getrgbaData(hexString: hexString)

        if(rgbaData != nil){

            self.init(
                        .sRGB,
                        red:     Double(rgbaData!.r),
                        green:   Double(rgbaData!.g),
                        blue:    Double(rgbaData!.b),
                        opacity: Double(rgbaData!.a)
                    )
            return
        }
        return nil
    }

    func toHex() -> String {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return "#000000"
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return "#\(String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255)))"
        } else {
            return "#\(String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)))"
        }
    }
}

extension UIColor {

    public convenience init?(hexString: String) {

        let rgbaData = getrgbaData(hexString: hexString)

        if(rgbaData != nil){
            self.init(
                        red:   rgbaData!.r,
                        green: rgbaData!.g,
                        blue:  rgbaData!.b,
                        alpha: rgbaData!.a)
            return
        }
        return nil
    }
}

    func getrgbaData(hexString: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {

    var rgbaData : (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? = nil

    if hexString.hasPrefix("#") {

        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...]) // Swift 4

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {

            rgbaData = { // start of a closure expression that returns a Vehicle
                switch hexColor.count {
                case 8:

                    return ( r: CGFloat((hexNumber & 0xff000000) >> 24) / 255,
                             g: CGFloat((hexNumber & 0x00ff0000) >> 16) / 255,
                             b: CGFloat((hexNumber & 0x0000ff00) >> 8)  / 255,
                             a: CGFloat( hexNumber & 0x000000ff)        / 255
                           )
                case 6:

                    return ( r: CGFloat((hexNumber & 0xff0000) >> 16) / 255,
                             g: CGFloat((hexNumber & 0x00ff00) >> 8)  / 255,
                             b: CGFloat((hexNumber & 0x0000ff))       / 255,
                             a: 1.0
                           )
                default:
                    return nil
                }
            }()

        }
    }

    return rgbaData
}
