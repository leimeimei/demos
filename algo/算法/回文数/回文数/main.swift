//
//  main.swift
//  回文数
//
//  Created by sun on 2018/5/23.
//  Copyright © 2018年 sun. All rights reserved.
//

import Foundation

//判断是否是回文数，负数不是，0是，121是

func isPalindromeNum(num: Int) -> Bool {
    if num < 0 {
        return false
    } else if (num == 0) {
        return true
    } else {
        var temp = num
        var y = 0
        while temp != 0 {
            y = y * 10 + temp % 10
            temp = temp / 10
        }
        if y == num {
            return true
        } else {
            return false
        }
    }
}

print(isPalindromeNum(num: 123454321))

