//
//  main.swift
//  直方图
//
//  Created by sun on 2018/5/23.
//  Copyright © 2018年 sun. All rights reserved.
//

import Foundation
//求柱状图中最大面积
func largestRectangleArea(array:[Int]) -> Int {
    var stack = [Int]()
    var heights = Array(array)
    heights.append(0)
    var sum = 0
    var i = 0
    while i < heights.count {
        if (stack.isEmpty || heights[i] > heights[stack.last ?? 0]) {
            stack.append(i)
            i = i + 1
        } else {
            let t = stack.last!
            stack.removeLast()
            sum = max(sum, heights[t] * (stack.isEmpty ? i : i - stack.last! - 1))
        }
        print("----------")
        print("i = \(i), sum = \(sum), stack = \(stack)")
    }
    return sum;
}

let array = [2,1,5,6,2,3];
let max = largestRectangleArea(array: array)
print(max)

