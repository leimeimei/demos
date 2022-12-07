//
//  NibOwnerLoadable.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import Foundation
import UIKit

protocol NibOwerLoadable: AnyObject {
    static var nib: UINib { get }
}

extension NibOwerLoadable {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibOwerLoadable where Self: UIView {
    func loadNibContent() {
        let layoutAttributes: [NSLayoutConstraint.Attribute] = [.top, .leading, .bottom, .trailing]
        for case let view as UIView in Self.nib.instantiate(withOwner: self, options: nil) {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            NSLayoutConstraint.activate(layoutAttributes.map({ attribute in
                NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: self, attribute: attribute, multiplier: 1, constant: 0)
            }))
        }
    }
}
