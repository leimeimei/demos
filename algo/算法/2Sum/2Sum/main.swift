//
//  main.swift
//  2Sum
//
//  Created by sun on 2018/5/21.
//  Copyright © 2018年 sun. All rights reserved.
//

import Foundation

/*
 “这道题目的意思是给定一个数组和一个值，让求出这个数组中两个值的和等于这个给定值的坐标。输出是有要求的，1， 坐标较小的放在前面，较大的放在后面。2， 这俩坐标不能为零。”
 
 把数组放在map中，key为值，value为下标，此处用字典代替，然后遍历数组，用target减去数组中元素，得到差，然后在字典中去找这个差，看有没有
*/

func twoSum(_ a:[Int],_ target:Int) -> (Int, Int) {
    var ret = (0,0)
    if a.count <= 1 {
        return ret
    }
    var dict = [Int:Int]()
    
    for (i, item) in a.enumerated() {
        dict[item] = i
    }
    for (i,item) in a.enumerated() {
        let rest = target - item
        guard let index = dict[rest] else { continue }
        if index != dict.count {
            if index == i {//忽略本身，找下标不同的其他数字
                continue
            }
            if index < i {
                ret.0 = index
                ret.1 = i
                return ret
            } else {
                ret.0 = i
                ret.1 = index
                return ret
            }
        }
    }
    return ret
}

let nums = [2,7,11,14,13]
let targret = 15
let result = twoSum(nums, targret)
print(result)


