//
//  main.swift
//  MissingNumber
//
//  Created by sun on 2018/5/23.
//  Copyright © 2018年 sun. All rights reserved.
//

import Foundation

//从0到n之间取出n个不同的数，找出漏掉的那个,要注意0的情况
//[0,1,3]

//求和
func findNum(array: [Int], n: Int) -> Int {
    let len = n + 1
    assert(len - array.count == 1)
    var sum1 = 0
    var sum2 = 0
    for item in array {
        sum1 += item
    }
    for i in 0...n {
        sum2 += i
    }
    return sum2 - sum1
}

//异或运算
func findNum1(array: [Int], n: Int) -> Int {
    var x = 0
    for item in array {
        x ^= item
    }
    for i in 0...n {
        x ^= i
    }
    return x
}

var array = [0,1,3]
print(findNum1(array: array, n: 3))
