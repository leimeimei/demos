//
//  BaseNavigationController.swift
//  ReaderExample
//
//  Created by sun on 2021/12/30.
//

import Foundation
import UIKit

class BaseNavitationController: NavigationController {
    private lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "navigation_back_white"), for: .normal)
        backBtn.titleLabel?.isHidden = true
        backBtn.addTarget(self, action: #selector(BaseNavitationController.backBtnClick), for: .touchUpInside)
        backBtn.contentHorizontalAlignment = .left
        backBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        return backBtn
    }()
    
    @objc private func backBtnClick() {
        popViewController(animated: true)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            super.pushViewController(viewController, animated: true)
        }
    }
}
