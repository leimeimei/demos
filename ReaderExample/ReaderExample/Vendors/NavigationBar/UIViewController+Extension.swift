//
//  UIViewController+Extension.swift
//  ReaderExample
//
//  Created by sun on 2021/12/30.
//

import UIKit

extension UIViewController {
    private struct AssociatedObjectKey {
        static var navigationBarConfigureKey: UInt8?
    }
    
    private var _navigationBarConfigure: NavigationBarConfigure? {
        get {
            objc_getAssociatedObject(self, &AssociatedObjectKey.navigationBarConfigureKey) as? NavigationBarConfigure
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKey.navigationBarConfigureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open var navigationBarConfigure: NavigationBarConfigure {
        get {
            if let configure = _navigationBarConfigure { return configure }
            let configure = NavigationBarConfigure()
            _navigationBarConfigure  = configure
            return configure
        }
        set {
            _navigationBarConfigure = newValue
        }
    }
    
    open func flushBarConfigure(_ animated: Bool = false) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBarConfigure.apply(to: navigationBar)
        navigationController?.setNavigationBarHidden(navigationBarConfigure.isHidden ?? false, animated: animated)
    }
    
    internal var originNavigationBarFrame: CGRect? {
        guard let bar = navigationController?.navigationBar else { return nil }
        guard let background = bar.value(forKey: "_backgroundView") as? UIView else { return nil }
        var frame = background.frame
        frame.origin = .zero
        return frame
    }
}
