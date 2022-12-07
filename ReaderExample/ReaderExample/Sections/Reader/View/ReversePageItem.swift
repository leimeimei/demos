//
//  ReversePageItem.swift
//  ReaderExample
//
//  Created by sun on 2021/12/30.
//

import UIKit

final class ReversePageItem: UIViewController {
    /// 章节索引
    var chapterIndex: Int = -1
    /// 章节内部分页索引
    var subrangeIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Appearance.readerBackgroundColor
    }
    
}
