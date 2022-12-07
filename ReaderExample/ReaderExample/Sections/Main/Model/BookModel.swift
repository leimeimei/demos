//
//  BookModel.swift
//  ReaderExample
//
//  Created by sun on 2021/12/30.
//

import Foundation

struct BookModel: BookResourceProtocol {
    var name: String
    var localPath: URL
    var lastAccessDate: Double
    var progress: Double
}

extension BookModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
