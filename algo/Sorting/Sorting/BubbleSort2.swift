//
//  BubbleSort2.swift
//  Sorting
//
//  Created by sun on 2019/10/11.
//  Copyright © 2019 sun. All rights reserved.
//

import Cocoa

/*
 使用标记，如果某一次排序后，整个数组已经有序，提前返回。
 针对接近有序的数组有效，对完全无序的数组没有优化效果
 */

class BubbleSort2: Sort {
    override func sort() {
        for end in (1...array.count-1).reversed() {
            var sorted = true
            for begin in (1...end) {
                if cmp(i1: begin, i2: begin-1) {
                    swap(i1: begin, i2: begin-1)
                    sorted = false
                }
            }
            if sorted { break }
        }
    }
}
