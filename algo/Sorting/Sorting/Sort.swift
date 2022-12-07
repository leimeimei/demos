//
//  Sort.swift
//  Sorting
//
//  Created by sun on 2019/10/10.
//  Copyright © 2019 sun. All rights reserved.
//

import Foundation

public class Sort: Comparable  {
    
    internal var array: [Int] = [Int]()
    private var cmpCount: Int = 0
    private var swapCount: Int = 0
    private var time: Double = 0
    
    public func sort(arr: [Int]) -> [Int] {
        if arr.count < 2 { return arr}
        self.array = arr
        let begin = Date.timeIntervalSinceReferenceDate
        sort();
        time = Date.timeIntervalSinceReferenceDate - begin
        return self.array
    }
    
    func sort() {}
    
    internal func cmp(i1: Int, i2: Int) -> Bool {
        cmpCount += 1
        return array[i1] < array[i2]
    }
    
    internal func cmp(idx1: Int, idx2: Int) -> Int {
        cmpCount += 1
        if array[idx1] < array[idx2] { return -1 }
        if array[idx1] == array[idx2] { return 0 }
        return 1
    }
    
    internal func cmp(v1: Int, v2: Int) -> Bool {
        cmpCount += 1
        return v1 < v2
    }
    
    internal func cmp(value1: Int, value2: Int) -> Int {
        cmpCount += 1
        if value1 < value2 { return -1 }
        if value1 == value2 { return 0 }
        return 1
    }
    
    internal func swap(i1: Int, i2: Int) {
        swapCount += 1
        let tmp = array[i1]
        array[i1] = array[i2]
        array[i2] = tmp
    }
    
    public func toString() -> String {
        let timeStr = "耗时:" + numberString(number: Int(time)) + "s"
        let compareCountStr = "比较:" + numberString(number: cmpCount)
        let swapStr = "交换:" + numberString(number: swapCount)
//        let stableStr =  "稳定性:" + "\(isStable())"
        let classStr = "\(type(of: self))"
        
        return "【" + classStr + "】\n"
//                + stableStr + "\t"
                + timeStr + "\t\t"
                + compareCountStr + "\t\t"
                + swapStr + "\n"
                + "----------------------------------"
    }
    
    private func numberString(number: Int) -> String {
        if number < 10000 { return String(number) }
        if number < 100000000 { return String(number / 10000) + "万" }
        return String(number / 10000) + "亿"
    }
    
//    private func isStable() -> Bool {
//        var arr = [Student]()
//        for i in (0...19) {
//            arr.append(Student(score: i * 10, age: 10))
//        }
//
//        sort(arr: arr)
//
//        for i in (1...19) {
//            let score = arr[i].score;
//            let preScore = arr[i-1].score
//            if (score != preScore + 10) { return false }
//        }
//        return true
//    }
    
    
    
    public static func < (lhs: Sort, rhs: Sort) -> Bool {
        let result = lhs.time - rhs.time
        if result < 0 {
            return true
        }
        let result1 = lhs.cmpCount - rhs.cmpCount
        if result1 < 0 {
            return true
        }
        return lhs.swapCount < rhs.swapCount
    }
    
    public static func == (lhs: Sort, rhs: Sort) -> Bool {
        return lhs.time == rhs.time && lhs.cmpCount == rhs.cmpCount && lhs.swapCount == rhs.swapCount
    }
}
