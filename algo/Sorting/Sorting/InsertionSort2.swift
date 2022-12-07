//
//  InsertionSort2.swift
//  Sorting
//
//  Created by sun on 2019/10/15.
//  Copyright © 2019 sun. All rights reserved.
//

import Cocoa

/*
 每一轮比较，记录当前位置的值，将比这个值大的元素全部往后移一位，最后将值插入到最前面的位置
 将交换操作改为了移动操作，减少了交换次数
 */

class InsertionSort2: Sort {
    override func sort() {
        for begin in (1..<array.count) {
            var current = begin
            let value = array[current]
            while current > 0 && cmp(value1: value, value2: array[current-1]) < 0 {
                array[current] = array[current - 1]
                current -= 1
            }
            array[current] = value
        }
    }
}
