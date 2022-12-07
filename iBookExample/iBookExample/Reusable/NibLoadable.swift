//
//  NibLoadable.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import Foundation
import UIKit

protocol NibLoadable: AnyObject {
    static var nib: UINib { get }
}

extension NibLoadable {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibLoadable where Self: UIView {
    static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("the nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}
