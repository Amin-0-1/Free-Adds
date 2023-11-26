//
//  GradientView.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    private var gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var firstColor: UIColor = .clear {
        didSet {
            updateGradientColors()
        }
    }
    
    @IBInspectable
    var secondColor: UIColor = .clear {
        didSet {
            updateGradientColors()
        }
    }
    
    @IBInspectable
    var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            gradientLayer.startPoint = startPoint
        }
    }
    
    @IBInspectable
    var endPoint: CGPoint = CGPoint(x: 0.0, y: 1.0) {
        didSet {
            gradientLayer.endPoint = endPoint
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupGradient()
    }
    
    private func setupGradient() {
        updateGradientColors()
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the gradient layer's frame when the view's bounds change
        gradientLayer.frame = bounds
    }
}
