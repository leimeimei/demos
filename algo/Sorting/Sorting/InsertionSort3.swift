//
//  InsertionSort3.swift
//  Sorting
//
//  Created by sun on 2019/10/15.
//  Copyright © 2019 sun. All rights reserved.
//

import Cocoa

/*
 利用二分搜索查找位置 log(n)，跟原来的写法相比，减少了比较次数
 时间复杂度: n*log(n)
 */

class InsertionSort3: Sort {
    override func sort() {
        for begin in (1..<array.count) {
            insert(source: begin, dest: search(index: begin))
        }
    }
    
    
    /// 将source位置的元素插入到dest位置
    private func insert(source: Int, dest: Int) {
        let value = array[source]
        var i = source
        while i > dest {
            array[i] = array[i-1]
            i -= 1
        }
        array[dest] = value
    }
    
    
    /// 利用二分搜索找到index位置元素的待插入位置
    /// 已经排好序数组的区间范围是[0， index）
    private func search(index: Int) -> Int {
        var begin = 0
        var end = index
        while begin < end {
            let mid = begin + (end - begin) >> 1
            if cmp(value1: array[index], value2: array[mid]) < 0 {
                end = mid
            } else {
                begin = mid + 1
            }
        }
        return begin
    }
}
