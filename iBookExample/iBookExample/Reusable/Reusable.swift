//
//  Reusable.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import Foundation

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

typealias NibReusable = Reusable & NibLoadable
