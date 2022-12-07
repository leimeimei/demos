//
//  SelectionSort1.swift
//  Sorting
//
//  Created by sun on 2019/10/12.
//  Copyright © 2019 sun. All rights reserved.
//

import Cocoa

/*
 o(n^2)
 每一轮排序，记录最大的那个值的索引，和最后一个元素交换，这样每一轮都把当轮最大的值放到最后
 比冒泡排序，减少了交换的次数
 */

class SelectionSort: Sort {
    override func sort() {
        for end in (1...array.count-1).reversed() {
            var maxIndex = 0
            for begin in (1...end) {
                if cmp(idx1: maxIndex, idx2: begin) <= 0 {
                    maxIndex = begin
                }
            }
            swap(i1: maxIndex, i2: end)
        }
    }
}
