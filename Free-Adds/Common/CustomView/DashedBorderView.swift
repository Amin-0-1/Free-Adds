//
//  DashedBorderView.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import UIKit

@IBDesignable
class DashedBorderView: UIView {
    
    private var dashedBorderLayer = CAShapeLayer()
    
    @IBInspectable
    var dashedBorderWidth: CGFloat = 1.5 {
        didSet {
            dashedBorderLayer.lineWidth = dashedBorderWidth
        }
    }
    
    @IBInspectable
    var dashedBorderColor: UIColor = .black {
        didSet {
            dashedBorderLayer.strokeColor = dashedBorderColor.cgColor
        }
    }
    
    @IBInspectable
    var dashedBorderPattern: CGPoint = .init(x: 4, y: 4) {
        didSet {
            dashedBorderLayer.lineDashPattern = [
                NSNumber(value: Float(dashedBorderPattern.x)),
                NSNumber(value: Float(dashedBorderPattern.y))
            ]
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDashedBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDashedBorder()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupDashedBorder()
    }
    
    private func setupDashedBorder() {
        dashedBorderLayer.strokeColor = dashedBorderColor.cgColor
        dashedBorderLayer.lineWidth = dashedBorderWidth
        dashedBorderLayer.lineDashPattern = [
            NSNumber(value: Float(dashedBorderPattern.x)),
            NSNumber(value: Float(dashedBorderPattern.y))
        ]
        dashedBorderLayer.fillColor = nil
        layer.addSublayer(dashedBorderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the dashed border layer's path when the view's bounds change
        updateDashedBorderPath()
    }
    
    private func updateDashedBorderPath() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        dashedBorderLayer.path = path.cgPath
    }
}
