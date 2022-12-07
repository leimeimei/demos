

import Foundation

/**
 二分查找：
 底层依赖于顺序表结构，简单说即数组，不适合链表，因为链表的查找时间复杂度是O(n),不支持随机访问
 只能针对有序数据
 针对频繁更新的动态数据，不适合二分查找，因为每次都要排序，排序最快的方法时间复杂度为0(nlogn),所以适合一次排序多次查找的场景（静态数据）
 数据太小不适合，除非数据之间的比较操作很耗时间
 数据太大也不适合，因为依赖于数组结构，需要连续的存储空间，数据量太大，可能超出内存大小
 */

// 简单二分
func search1(a: [Int], target: Int) -> Int {
    let count = a.count
    var low = 0, high = count - 1
    while low <= high {
        let mid = low + (high - low) >> 1
        if a[mid] == target {
            return mid
        } else if a[mid] > target {
            high = mid - 1
        } else {
            low = mid + 1
        }
    }
    return -1
}

// 递归

//func search2(a: [Int], target: Int) -> Int {
//    let count = a.count
//    下面一行错误，这样写，每次传递的数组都改变了。找到的index已经不是原数组的index，是当前栈里的index
//    var low = 0, high = count - 1
//    var mid = low + (high - low) >> 1
//    if a[mid] == target {
//        return mid
//    } else if a[mid] < target {
//        return search2(a:Array(a[mid+1...high]), target: target)
//    } else {
//        return search2(a:Array(a[low...mid-1]), target: target)
//    }
//}


// 正确写法
func search2(a: [Int], low: Int, high: Int, target: Int) -> Int {
    let mid = low + (high - low) >> 1
    if a[mid] == target {
        return mid
    } else if a[mid] < target {
        return search2(a:a,low:mid+1, high:high, target: target)
    } else {
        return search2(a:a,low:low, high:mid-1, target: target)
    }
}

let a = [1,2,3,5,6,9,12,45,88,90]
print(search1(a:a, target:9))
print(search2(a:a,low:0, high:a.count-1, target: 9))







