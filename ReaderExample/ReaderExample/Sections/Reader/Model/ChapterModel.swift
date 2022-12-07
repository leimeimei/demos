//
//  ChapterModel.swift
//  ReaderExample
//
//  Created by sun on 2021/12/30.
//

import Foundation

class ChapterModel {
    var title: String?
    var content: String
    var range: NSRange
    private var _subranges: [NSRange]?
    var subranges: [NSRange] {
        if _subranges == nil {
            _subranges = content.pageRanges(attributes: Appearance.attributes, constraintSize: Appearance.displayRect.size)
        }
        return _subranges!
    }
    init(title: String? = nil, content: String, range: NSRange) {
        self.title = title
        self.content = content
        self.range = range
    }
    func updateSubranges() {
        _subranges = nil
    }
}
