//
//  main.swift
//  AddBinary
//
//  Created by sun on 2018/5/24.
//  Copyright © 2018年 sun. All rights reserved.
//

import Foundation

/*
 Given two binary strings, return their sum (also a binary string).
 
 For example,
 a = "11"
 b = "1"
 Return "100".
 
 从后往前相加并处理进位，相同位置2个数，同为0或者同为1，相加结果肯定为0，不同为1，如果同为1，则有进位，如果相加后本位置为1，本位制的进位也为1，则本位置为0，需要继续进位
 每一位置的最终结果为：先把2个二进制数相加，得出结果s为0或者1，在和本位置的进位add相加，得出结果sj为0或1，才是最终结果
 */

func addBinary(a: NSString, b: NSString) -> String {
    var result = String()
    let la = a.length
    let lb = b.length
    if la == 0 {
        return b as String
    }
    
    if lb == 0 {
        return a as String
    }
    
    let lmax = max(la, lb)
    var add = "0"//进位，默认最开始一个位置的进位为0
    
    for i in 0..<lmax {
        //取对应位置的二进制值，有就取，没有则视为0，加0不影响结果
        let ca = la > i ? a.substring(with: NSMakeRange(la-1-i, 1)) : "0"
        let cb = lb > i ? b.substring(with: NSMakeRange(lb-1-i, 1)) : "0"
        let s = (ca == cb ? "0" : "1")//二进制位相同位置2个数字同为0或者同为1，相加为0，不同则此位置肯定为1
        let sj = (s == add ? "0" : "1") //相同位置的2个数字相加后，和本位的进位相加，相同为0，不同为1
        if ca == "1" && cb == "1" || s == "1" && add == "1" {//判断是否有进位
            add = "1"
        } else {
            add = "0"
        }
        result += sj //当前位置2个数（0或者1）的相加后的结果
    }
    if add == "1" {//如果最后有进位，则要加上1位，值为1
        result += add
    }
    
    return String(result.reversed()) //字符串逆序得到正确的二进制数
}

print(addBinary(a: "101", b: "11"))

