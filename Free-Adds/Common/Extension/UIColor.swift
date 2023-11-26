//
//  UIColor.swift
//  Football-Leagues
//
//  Created by Amin on 21/10/2023.
//

import UIKit

extension UIColor {
    /// Custom colors added into the assets
    enum CustomColorName: String {
        case mainColor
    }
    /// get custom color by its name
    /// - Parameter name: constant value for custom names
    /// - Returns: UIColor
    static func customColor(_ name: CustomColorName) -> UIColor {
        return UIColor(named: name.rawValue) ?? .clear
    }
    
    /// get random UIColor
    /// - Parameter alpha: transparancy value, default = 1
    /// - Returns: returns UIColor
    static func randomColor(alpha: CGFloat = 1) -> UIColor {
        let red = CGFloat.random(in: 0.0...1.0)
        let green = CGFloat.random(in: 0.0...1.0)
        let blue = CGFloat.random(in: 0.0...1.0)
        return .init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
