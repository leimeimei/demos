//
//  String+Ex.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import UIKit

extension String {
    
    func size(for font: UIFont, size: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        var attr:[NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        if lineBreakMode != .byWordWrapping {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode
            attr[.paragraphStyle] = paragraphStyle
        }
        let rect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attr, context: nil)
        return rect.size
    }
    func width(for font: UIFont) -> CGFloat {
        size(for: font, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).width
    }
}

extension NSAttributedString {
    convenience init(string: String, font: UIFont, color: UIColor = UIColor.black) {
        self.init(string: string, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
    }
}
