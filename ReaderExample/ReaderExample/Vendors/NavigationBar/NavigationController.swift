//
//  NavigationController.swift
//  ReaderExample
//
//  Created by sun on 2021/12/30.
//

import UIKit

open class NavigationController: UINavigationController {
    private lazy var toFakeBar: UIToolbar = UIToolbar()
    private lazy var fromFakeBar: UIToolbar = UIToolbar()
    
    open lazy var defaultNavigationConfigure: NavigationBarConfigure = {
        let config = NavigationBarConfigure()
        config.barStyle = .default
        config.isTranslucent = true
        config.isHidden = false
        return config
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        
        delegate = self
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        visibleViewController!.supportedInterfaceOrientations
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        visibleViewController?.preferredStatusBarStyle ?? .lightContent
    }
    
    open override var prefersStatusBarHidden: Bool {
        visibleViewController!.prefersStatusBarHidden
    }
    
}

extension NavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationBarConfigure.fillSelfEmptyValue(with: defaultNavigationConfigure)
        if (viewController.navigationBarConfigure.isHidden ?? false) != navigationController.navigationBar.isHidden {
            navigationController.setNavigationBarHidden(viewController.navigationBarConfigure.isHidden ?? false, animated: animated)
        }
        
        if animated == false { return }
        
        navigationController.navigationBar.barTintColor = nil
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        (navigationController.navigationBar.value(forKey: "_backgroundView") as? UIView)?.isHidden = true
        navigationController.transitionCoordinator?.animate(alongsideTransition: { ctx in
            guard let fromVc = ctx.viewController(forKey: .from),
                  let toVC = ctx.viewController(forKey: .to) else { fatalError("nil") }
            fromVc.navigationBarConfigure.fillSelfEmptyValue(with: self.defaultNavigationConfigure)
            if (fromVc.navigationBarConfigure.isHidden ?? false) != false {
                if let fakeBarFrame = fromVc.originNavigationBarFrame {
                    self.fromFakeBar.frame = fakeBarFrame
                    fromVc.navigationBarConfigure.apply(to: self.fromFakeBar)
                    fromVc.view.addSubview(self.fromFakeBar)
                }
            }
            toVC.navigationBarConfigure.fillSelfEmptyValue(with: self.defaultNavigationConfigure)
            if (toVC.navigationBarConfigure.isHidden ?? false) == false {
                if let fakeBarFrame = toVC.originNavigationBarFrame {
                    self.toFakeBar.frame = fakeBarFrame
                    toVC.navigationBarConfigure.apply(to: self.toFakeBar)
                    toVC.view.addSubview(self.toFakeBar)
                }
                // 提前设置这几项，过渡自然一点
                navigationController.navigationBar.tintColor = toVC.navigationBarConfigure.barTintColor
                navigationController.navigationBar.titleTextAttributes = toVC.navigationBarConfigure.titleTextAttributes
                navigationController.navigationBar.barStyle = toVC.navigationBarConfigure.barStyle ?? .default
            }
        }, completion: { ctx in
            if ctx.isCancelled {
                self.fromFakeBar.removeFromSuperview()
                self.toFakeBar.removeFromSuperview()
                guard let fromVC = ctx.viewController(forKey: .from) else { fatalError("nil") }
                fromVC.navigationBarConfigure.apply(to: self.navigationBar)
                if fromVC.navigationBarConfigure.isHidden != self.navigationBar.isHidden {
                    navigationController.setNavigationBarHidden(fromVC.navigationBarConfigure.isHidden ?? false, animated: animated)
                }
            }
        })
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.fromFakeBar.removeFromSuperview()
        self.toFakeBar.removeFromSuperview()
        viewController.navigationBarConfigure.apply(to: navigationController.navigationBar)
        (navigationController.navigationBar.value(forKey: "_backgroundView") as? UIView)?.isHidden = false
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
