//
//  main.swift
//  PowerOfTwo
//
//  Created by sun on 2018/5/24.
//  Copyright © 2018年 sun. All rights reserved.
//

import Foundation


//如果是2的幂，那么这个数的二进制形式只可能有一个1，如果出现2个或者以上，证明不是2的幂
//负数不能这样判断
func isPowerOfTwo(number: Int) -> Bool {
    var num = number
    if num < 0 {
        return false
    }
    var hasOne = false
    while num > 0 {
        if (num & 1) == 1 {//如果遇到1
            if hasOne {
                return false //如果再次遇到1，直接返回false
            } else {
                hasOne = true //第一次遇到1会把hasOne置为true
            }
        }
        num >>= 1  //右移等于除2，每次右移一位，判断每一位
    }
    return hasOne
}

print(isPowerOfTwo(number: 9))




//关于&运算的另外一个示例：
/*
 “给出一个整数，求它包含二进制1的位数。例如，32位整数11的二进制表达形式是00000000000000000000000000001011，那么函数应该返回3。
 
 题目分析: 设输入的数为n，把n与1做二进制的与(AND)运算，即可判断它的最低位是否为1。如果是的话，把计数变量加一。然后把n向右移动一位，重复上述操作。当n变为0时，终止算法，输出结果。”
 */

func countOne(number: Int) -> Int {
    var num = number
    var count = 0
    while num > 0 {
        count += num & 1
        num >>= 1
    }
    return count
}
print(countOne(number: 15))
