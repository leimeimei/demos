//
//  main.swift
//  PlusOne
//
//  Created by sun on 2018/5/23.
//  Copyright © 2018年 sun. All rights reserved.
//

import Foundation
// 999 + 1 = 1000
func plusOne(array: inout [Int]) {
    var sum = 0;
    var one = 1;
    for (index, item) in array.enumerated().reversed() {
        sum = one + item
        one = sum / 10
        array[index] = sum % 10
    }
    if one > 0 {
        array.insert(one, at: 0)
    }
}

var array = [9,9,9];
plusOne(array: &array)
print(array)

func change(num:Int) -> [Int] {
    var ret = [Int]()
    var a = num
    
    repeat {
        ret.append(a%10)
        a = a/10
    } while a > 0
    
    return ret.reversed()
}
print(change(num: 999))

