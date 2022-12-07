//
//  main.swift
//  Fibonacci
//
//  Created by sun on 2018/5/23.
//  Copyright © 2018年 sun. All rights reserved.
//

import Foundation

//斐波那契数列

//求第N项
func fibonacci(n: Int) -> Int {
    assert(n >= 0)
    if n == 0 {
        return 0
    } else if n == 1 {
        return 1
    } else {
        var i = 2
        var first = 0
        var second = 1
        var third = 0
        while i <= n {
            third = first + second
            first = second
            second = third
            i = i + 1
        }
        return third
    }
}
print(fibonacci(n: 6))

//求N项斐波那契数列
func fibonacci1(n: Int) -> [Int] {
    assert(n >= 1)
    var result: [Int] = Array(repeating: 0, count: n)
    if n-1 == 0 {
        result[0] = 0
    } else if n-1 == 1 {
        result[0] = 0
        result[1] = 1
    } else {
        result[0] = 0
        result[1] = 1
        var i = 2
        while i <= n-1 {
            result[i] = result[i - 1] + result[i - 2]
            i = i + 1
        }
    }
    
    return result
}
print(fibonacci1(n: 7))

