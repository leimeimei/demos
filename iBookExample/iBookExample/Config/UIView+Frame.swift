//
//  UIView+Frame.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import UIKit

extension UIView {

    // swiftlint:disable identifier_name
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    public var size: CGSize {
        get {
            return self.frame.size
        }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    public var origin: CGPoint {
        get {
            return self.frame.origin
        }
        
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    public var centerX: CGFloat {
        
        get {
            return self.center.x
        }
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    public var centerY: CGFloat {
        
        get {
            return self.center.y
        }
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
}

extension UIView {
    
    func snapshotImage(_ iSize: CGSize) -> UIImage {
        
        let scale: CGFloat = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(iSize, false, scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    var snapshot: UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func applyGradient(withColors colors: [UIColor]) {
        if let sublayers = layer.sublayers {
            let _ = sublayers.filter({ $0 is CAGradientLayer }).map({ $0.removeFromSuperlayer() })
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map({ $0.cgColor })
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyScale(_ scale: CGFloat) {
        layer.transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1.0)
    }
}
