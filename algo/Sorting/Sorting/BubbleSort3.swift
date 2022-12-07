//
//  BubbleSort3.swift
//  Sorting
//
//  Created by sun on 2019/10/11.
//  Copyright © 2019 sun. All rights reserved.
//

import Cocoa

/*
 使用标记，记录每一轮排序最后一个交换的位置，就是下一轮排序的结束位置。这个位置后面的都是有序的。
 针对部分有序的数组有效，对完全无序的数组没有优化效果
 减少比较的次数
 */

class BubbleSort3: Sort {
    override func sort() {
        var end = array.count - 1
        while end > 1 {
            var sortedIndex = 1
            for begin in (1...end) {
                if cmp(i1: begin, i2: begin-1) {
                    swap(i1: begin, i2: begin-1)
                    sortedIndex = begin
                }
            }
            end = sortedIndex
        }
    }
}
