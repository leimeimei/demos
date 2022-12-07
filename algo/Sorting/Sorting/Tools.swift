//
//  Tools.swift
//  Sorting
//
//  Created by sun on 2019/10/10.
//  Copyright © 2019 sun. All rights reserved.
//

import Foundation



public func random(min: Int, max: Int, count: Int) -> [Int] {
    if count <= 0 || min > max {
        return [Int]()
    }
    var arr = Array<Int>.init()
    for _ in (0..<count) {
        arr.append(Int(arc4random_uniform(UInt32(max)) + 1))
    }
    return arr
}

public func ascOrder(min: Int, max: Int) -> [Int] {
    if min > max { return [Int]() }
    var arr = Array<Int>.init()
    for i in (0...max-min) {
        arr.append(min+i)
    }
    return arr
}

public func reverse(array: inout [Int], begin: Int, end: Int) {
    let count = (end - begin) >> 1
    let sum = begin + end - 1
    for i in (0..<(begin + count)) {
        let j = sum - i
        array.swapAt(i, j)
    }
}

public func tailAscOrder(min: Int, max: Int, disOrderCnt: Int) -> [Int] {
    var arr = ascOrder(min: min, max: max)
    if disOrderCnt > arr.count {
        return arr
    }
    reverse(array: &arr, begin: 0, end: disOrderCnt)
    return arr
}

public func isAscOrder(array: [Int])  -> Bool {
    if array.count == 0 {
        return false
    }
    for idx in (1..<array.count) {
        if array[idx-1] > array[idx] { return false }
    }
    return true
}


