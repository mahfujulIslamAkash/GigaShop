//
//  UIView+Extension.swift
//  GigaShop
//

import UIKit
import Foundation

//extension UIView
extension UIView{
    
    func centerX(withView view: UIView, multiplier: CGFloat, constant: CGFloat) {
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: multiplier, constant: constant).isActive = true
    }
    
    func centerY(withView view: UIView, multiplier: CGFloat, constant: CGFloat) {
        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: multiplier, constant: constant).isActive = true
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor , gradientLayer: CAGradientLayer) {
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x:1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        gradientLayer.needsDisplayOnBoundsChange = true
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func anchorView(top: NSLayoutYAxisAnchor? = nil,
                    left: NSLayoutXAxisAnchor? = nil,
                    bottom: NSLayoutYAxisAnchor? = nil,
                    right: NSLayoutXAxisAnchor? = nil,
                    paddingTop: CGFloat = 0,
                    paddingLeft: CGFloat = 0,
                    paddingBottom: CGFloat = 0,
                    paddingRight: CGFloat = 0,
                    width: CGFloat? = nil,
                    height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let lefts = leftAnchor {
            anchorView(left: lefts, paddingLeft: paddingLeft)
        }
    }
    
    public var width: CGFloat{
        return frame.size.width
    }
    public var height: CGFloat{
        return frame.size.height
    }
    public var top: CGFloat{
        return frame.origin.y
    }
    public var bottom: CGFloat{
        return frame.origin.y + frame.size.height
    }
    public var left: CGFloat{
        return frame.origin.x
    }
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func adShadowForIconList(){
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
    
    enum ViewBorder: String {
        case left, right, top, bottom
    }
    
    func add(Border border: ViewBorder, withColor color: UIColor = UIColor.gray, andWidth width: CGFloat = 1.0, lineWithPaddingLeft: Bool = true) {
        
        let borderView = UIView()
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(borderView)
        NSLayoutConstraint.activate(getConstrainsFor(forView: borderView, WithBorderType: border, andWidth: width, lineWithPaddingLeft: lineWithPaddingLeft))
        
    }
    
    func setBorder(borderWidth : CGFloat = 1 , borderColor : UIColor = .red){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    private func getConstrainsFor(forView borderView: UIView, WithBorderType border: ViewBorder, andWidth width: CGFloat, lineWithPaddingLeft: Bool=true) -> [NSLayoutConstraint] {
        
        let height = borderView.heightAnchor.constraint(equalToConstant: width)
        let widthAnchor = borderView.widthAnchor.constraint(equalToConstant: width)
        let leading = borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lineWithPaddingLeft == true ? UIScreen.main.bounds.width*0.048309:0)
        let trailing = borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = borderView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        switch border {
                
            case .bottom:
                return [bottom, leading, trailing, height]
                
            case .top:
                return [top, leading, trailing, height]
                
            case .left:
                return [top, bottom, leading, widthAnchor]
                
            case .right:
                return [top, bottom, trailing, widthAnchor]
        }
    }
    
    func view(backgroundColor: UIColor, alpha: CGFloat) ->UIView{
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.alpha = alpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}


//#warning("test toast view for mine")
class ToastView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(message: String) {
        super.init(frame: CGRect.zero)
        configureUI()
        messageLabel.text = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor(hexString: "FF2DAF")
        layer.cornerRadius = 10
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    func show(in view: UIView, duration: TimeInterval = 2) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.dismiss()
            }
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    
}

extension UIView{
    static var shared = UIView()
    
//#warning("for my test, please ignore this warning")
    func showingToast(_ message: String = "Successfully Copied Url"){
        let toast = ToastView(message: message)
        if let window = UIApplication.shared.windows.first {
            if let currentView = window.rootViewController?.view{
                DispatchQueue.main.async {
                    toast.show(in: currentView)
                }
            }
            
        } else {
            // Handle the case where there is no window
            print("No window found")
        }
        
    }
    func copyToClipboard(_ path: String) {
        let pasteboard = UIPasteboard.general
        
        // Set the text to be copied
        pasteboard.string = path
        showingToast()
    }
}

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

