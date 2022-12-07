

import Foundation


/**
 二分查找的变形问题：
 1- 查找第一个值等于给定值的元素
 2- 查找最后一个值等于给定值的元素
 3- 查找第一个大于等于给定值的元素
 4- 查找最后一个小于等于给定值的元素
 */

//  [1,3,4,5,6,8,8,8,11,18] 有重复元素
func search1(a: [Int], target: Int) -> Int {
    var low = 0, high = a.count
    while low < high {
        let mid = low + (high - low) >> 1
        if a[mid] < target {
            low = mid + 1
        } else if a[mid] > target {
            high = mid
        } else {
            // mid的值就是目标值，但是是否是第一个？
            // 如果mid == 0，那这个肯定是就是第一个了，因为已经是数组第一个元素
            // 如果mid的前一个元素不是目标值，证明mid之前没有目标值，那么mid就是第一个目标值，所以mid就是要查找的index
            // 否则更新high，继续查找
            if mid == 0 || a[mid-1] != target {
                return mid
            }
            high = mid
        }
    }
    return -1
}

let a = [1,1,3,4,5,6,8,8,8,11,11,18,18]
print(search1(a:a, target:1))
print(search1(a:a, target:18))
print(search1(a:a, target:8))
print(search1(a:a, target:100))


// 2
func search2(a: [Int], target: Int) -> Int {
    var low = 0, high = a.count - 1
    while low <= high {
        let mid = low + (high - low) >> 1
        if a[mid] < target {
            low = mid + 1
        } else if a[mid] > target {
            high = mid - 1
        } else {
            if mid == a.count - 1 || a[mid+1] != target {
                return mid
            }
            low = mid + 1
        }
    }
    return -1
}

// 3
func search3(a: [Int], target: Int) -> Int {
    var low = 0, high = a.count - 1
    while low <= high {
        let mid = low + (high - low) >> 1
        if a[mid] >= target {
            if mid == 0 || a[mid-1] < target {
                return mid
            }
            high = mid - 1
        } else {
            low = mid + 1
        }
    }
    return -1
}


// 4
func search4(a: [Int], target: Int) -> Int {
    var low = 0, high = a.count - 1
    while low <= high {
        let mid = low + (high - low) >> 1
        if a[mid] > target {
            high = mid - 1
        } else {
            if mid == a.count - 1 || a[mid+1] > target {
                return mid
            }
            low = mid + 1
        }
    }
    
    return -1
}

//let a = [1,3,4,5,6,8,8,8,11,18]
//print(search1(a:a, target:8))
//print(search2(a:a, target:8))

// 对于3，4两种情况，数组中不能出现等于target的值，否则结果不正确
let b = [1,3,4,5,5,6,6,11,11,18]
//print(search3(a:b, target:8))
//print(search4(a:b, target:8))




///////////////////////////////////////////////////////////////////////////////
// 旋转数组（循环数组）二分查找示例


// 旋转的有序数组，查某个值
func rotateSearch1(a: [Int], target: Int) -> Int {
    
    var low = 0, high = a.count
    while low != high {
        let mid = low + (high - low) >> 1
        if a[mid] == target {
            return mid
        } else if a[low] <= a[mid] {
            if a[low] <= target && target <= a[mid] {
                high = mid
            } else {
                low = mid + 1
            }
        } else {
            if a[mid] < target && target < a[high-1] {
                low = mid + 1
            } else {
                high = mid
            }
        }
    }
    
    return -1
}

let c = [4,5,6,7,1,2,3]
//print(rotateSearch1(a: c, target: 1))



// 旋转有序数组，求最小值
func rotateSearch2(a: [Int]) -> Int {
    var low = 0, high = a.count - 1
    while low < high - 1 {
        if a[low] < a[high] {
            return a[low]
        }
        let mid = low + (high - low) >> 1
        if a[mid] > a[low] {
            low = mid
        } else if a[mid] < a[low] {
            high = mid
        }
    }
    
    
    return min(a[low], a[high])
}
let d = [4,5,6,7,1,2,3]
//print(rotateSearch2(a: d))


// 旋转有序数组，有重复，求最小值
func rotateSearch3(a: [Int]) -> Int {
    var low = 0, high = a.count - 1
    while low < high - 1 {
        if a[low] < a[high] {
            return a[low]
        }
        let mid = low + (high - low) >> 1
        if a[mid] > a[low] {
            low = mid
        } else if a[mid] < a[low] {
            high = mid
        } else {
            low += 1
        }
    }
    
    return min(a[low], a[high])
}

let e = [4,4,5,6,1,1,1,2,3]
//print(rotateSearch3(a: e))
