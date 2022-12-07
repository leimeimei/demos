//
//  Item.swift
//  Picture
//
//  Created by sun on 2022/10/31.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let url: URL
}

extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id && lhs.url == rhs.url
    }
}
