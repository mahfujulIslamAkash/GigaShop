//
//  GradientShadowView.swift
//  GigaShop
//

import UIKit

class GradientShadowView: UIView {
    override func draw(_ rect: CGRect) {
        // Create gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor] // Customize gradient colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        // Apply gradient as shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 15
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        
        // Insert gradient layer below other sublayers
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
