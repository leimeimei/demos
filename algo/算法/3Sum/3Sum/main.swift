//
//  main.swift
//  3Sum
//
//  Created by sun on 2018/5/21.
//  Copyright © 2018年 sun. All rights reserved.
//

import Foundation

func threeSum(_ array:inout [Int], _ target: Int) -> [(Int, Int, Int)] {
    var result = [(Int, Int, Int)]()
    
    if array.count < 3 {return result}
    
    array.sort()
    
    for (var i, _) in array.enumerated() {
        if i >= array.count - 2 { break }
        var j = i + 1
        var k = array.count - 1
        while (j < k) {
            var temp = (0,0,0)
            if (array[i] + array[j] + array[k] == target) {
                temp.0 = array[i]
                temp.1 = array[j]
                temp.2 = array[k]
                if !result.contains(where:{$0 == temp}) {
                    result.append(temp)
                }
                j = j + 1
                k = k - 1
                while (j < k && array[j-1] == array[j]) { j = j+1 } //去重
                while (j < k && array[k] == array[k+1]) { k = k-1 }
            } else if (array[i] + array[j] + array[k] < 0) {
                j = j + 1
            } else {
                k = k - 1
            }
            while (i < array.count - 1 && array[i] == array[i+1]) { i = i + 1} //去重
        }
    }
    return result
}
var array = [-1,0,1,2,3,-1,-4]
let result = threeSum(&array, 0)
print(result)

