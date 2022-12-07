//
//  UIColor+Extention.swift
//  ReaderExample
//
//  Created by sun on 2021/12/27.
//

import UIKit

extension UIColor {
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traintCollection) -> UIColor in
                if traintCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        }
        return light
    }
    
}
