//
//  InsertionSort1.swift
//  Sorting
//
//  Created by sun on 2019/10/15.
//  Copyright © 2019 sun. All rights reserved.
//

import Cocoa

/*
 o(n^2)
 每一轮比较，从最后一个位置开始，和前一个位置进行比较，如果前面的大，就交换，直到前面都有序
 */

class InsertionSort1: Sort {
    override func sort() {
        for begin in (1..<array.count) {
            var current = begin
            while current > 0, cmp(idx1: current, idx2: current-1) < 0 {
                swap(i1: current, i2: current-1)
                current -= 1
            }
        }
    }
}
