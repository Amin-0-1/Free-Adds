//
//  AnyInspectable.swift
//  Ristoranti
//
//  Created by Amin on 04/11/2023.
//

import UIKit

extension UIView {
    
    private var gradient: Gradient {
        return Gradient.shared
    }
    // MARK: - Corner Radius
    @IBInspectable
    var _CornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var _FullRounded: Bool {
        get {
            return layer.cornerRadius == frame.height / 2
        }
        set {
            if newValue {
                layer.cornerRadius = frame.height / 2
            }
        }
    }
    
    // MARK: - Border
    @IBInspectable
    var _BorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var _BorderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var _MasksToBounds: Bool {
        get {return layer.masksToBounds}
        set {
            layer.masksToBounds = newValue
        }
    }
    
    // MARK: - Shadow
    @IBInspectable
    var _ShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var _ShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var _ShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var _ShadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    // MARK: - Gradient
    @IBInspectable
    var _IsGradient: Bool {
        get {return false}
        set {
            if newValue {
                gradient.frame = bounds
            }
        }
    }
    
    @IBInspectable
    var _GradientColor1: UIColor {
        get {
            
            return gradient.firstColor
        }
        set {
            gradient.firstColor = newValue
            updateGradient()
        }
    }
    
    @IBInspectable
    var _GradientColor2: UIColor {
        get {
            return gradient.secondColor
        }
        set {
            gradient.secondColor = newValue
            updateGradient()
        }
    }
    @IBInspectable
    var _StartPoint: CGPoint {
        get {
            return .zero
        }
        set {
            gradient.startPoint = newValue
        }
    }
    @IBInspectable
    var _EndPoint: CGPoint {
        get {
            return .zero
        }
        set {
            gradient.endPoint = newValue
        }
    }
    
    private func updateGradient() {
        layer.insertSublayer(gradient.gradientLayer, at: 0)
    }
}

class Gradient {
    static let shared = Gradient()
    private (set) var gradientLayer: CAGradientLayer

    private init() {
        gradientLayer = .init()
        firstColor = .clear
        secondColor = .clear
        gradientLayer.colors = []
        startPoint = .init(x: 0, y: 0)
        endPoint = .init(x: 0, y: 1)
    }
    var frame: CGRect {
        get {
            return gradientLayer.frame
        }
        set {
            gradientLayer.frame = newValue
        }
    }
    
    var firstColor: UIColor {
        willSet {
            gradientLayer.colors?.append(newValue.cgColor)
        }
    }
    var secondColor: UIColor {
        willSet {
            gradientLayer.colors?.append(newValue.cgColor)
        }
    }
    var startPoint: CGPoint {
        willSet {
            gradientLayer.startPoint = newValue
        }
    }
    var endPoint: CGPoint {
        willSet {
            gradientLayer.endPoint = newValue
        }
    }
}
