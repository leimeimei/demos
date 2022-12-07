//
//  SelectionSort2.swift
//  Sorting
//
//  Created by sun on 2019/10/12.
//  Copyright © 2019 sun. All rights reserved.
//

import Cocoa

/*
 使用堆技术选最大的值
 先对数组进行原地建堆，重复以下步骤，直到堆的元素数量为1：
    1，交换堆顶元素与尾元素，（选出最大值放到末尾）
    2，堆的size减1
    3，对0位置进行1次siftDown操作，（交换后，需要维持堆的特性，维护大顶堆）
 */

/*
 减少了每轮选取最大值的比较操作
 建堆时间复杂度log(n),堆排序操作时间复杂度 o(n*log(n))
 */

class HeapSort: Sort {
    private var heapSize: Int = 0
    override func sort() {
        
        heapSize = array.count
        var idx = (heapSize >> 1) - 1
        while idx >= 0  {
            siftDown(idx: idx)
            idx -= 1
        }
        while heapSize > 1 {
            heapSize -= 1
            swap(i1: 0, i2: heapSize)
            siftDown(idx: 0)
        }
    }
    
    private func siftDown(idx: Int) {
        var index = idx
        let element = array[index]
        let half = heapSize >> 1
        while index < half { // index必须是非叶子节点
            var childIndex = (index << 1) + 1
            var child = array[childIndex]
            let rightIndex = childIndex + 1
            // 右子节点比左子节点大
            if rightIndex < heapSize && cmp(value1: array[rightIndex], value2: child) > 0 {
                childIndex = rightIndex
                child = array[childIndex]
            }
            
            // 大于等于子节点
            
            if cmp(value1: element, value2: child) >= 0 { break }
            
            array[index] = child
            index = childIndex
        }
        array[index] = element
    }
}
