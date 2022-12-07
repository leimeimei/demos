//
//  UIDevice+Extension.swift
//  ReaderExample
//
//  Created by sun on 2021/12/27.
//

import UIKit

extension UIDevice {
    static var isNotch: Bool {
        if #available(iOS 11, *) {
            return (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0) > 0
        } else {
            return false
        }
    }
}
