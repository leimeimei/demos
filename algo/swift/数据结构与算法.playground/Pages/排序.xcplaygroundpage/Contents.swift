

import Foundation

/*
 冒泡排序：
 原地排序，稳定排序
 空间复杂度：仅需少量交换，O(1)
 时间复杂度：最好O(n), 最差O(n^2),平均O(n^2)
 */

func bubbleSort(a: inout [Int]) {
    let count = a.count
    if count <= 1 { return }
    
    for i in 0..<count {
        var sorted = true  // 提前退出标志
        for j in 0..<count - 1 - i {
            if a[j] > a[j+1] {
                let tmp = a[j]
                a[j] = a[j+1]
                a[j+1] = tmp
                sorted = false  // 有数据交换
            }
        }
        if sorted { break } // 没有数据交换，标识已经都有序了
    }
}

// 记录某一轮排序中最后交换的位置，这个位置就是下一轮的结束位置
func bubbleSort1(a: inout [Int]) {
    let count = a.count
    if count <= 1 { return }
    
    var end = count - 1
    for _ in 0...end {
        var sortedIndex = 1
        for j in 0..<end {
            if a[j] > a[j+1] {
                let tmp = a[j]
                a[j] = a[j+1]
                a[j+1] = tmp
                sortedIndex = j
            }
        }
        end = sortedIndex
    }
}




/*
 插入排序：
 比较排序，原地排序，稳定排序
 空间复杂度：仅需少量交换，O(1)
 时间复杂度：最好O(n), 最差O(n^2),平均O(n^2)
 */

func insertSort(a: inout [Int]) {
    let count = a.count
    if count <= 1 { return }
    
    for i in 1..<count {
        let value = a[i]
        var j = i - 1
        while j >= 0 {
            if a[j] > value {
                a[j+1] = a[j]
                j = j - 1
            } else {
                break
            }
        }
        a[j+1] = value
    }
}





/*
 选择排序：
 比较排序，原地排序，稳定排序
 空间复杂度：仅需少量交换，O(1)
 时间复杂度：最好O(n^2), 最差O(n^2),平均O(n^2)
 */

func selectSort(a: inout [Int]) {
    let count = a.count
    if count <= 1 { return }
    
    for i in 0..<count-1 {
        var idx = i
        for j in i+1..<count {
            if a[j] <= a[idx] { // 稳定排序的关键是 <=，不能是<
                idx = j
            }
        }
        
//        let tmp = a[i]
//        a[i] = a[idx]
//        a[idx] = tmp
        (a[i], a[idx]) = (a[idx], a[i])
    }
}







/*
 归并排序：
 比较排序，非原地排序，稳定排序
 空间复杂度：仅需少量交换，O(n)
 时间复杂度：O(nlogn)
 分治思想和递归，先分组，直到每组只有一个元素，一个元素是有序的，在合并2个数组
 */
func merge(a: [Int], b: [Int]) -> [Int] {
    if a.count == 0 {
        return b
    }
    if b.count == 0 {
        return a
    }
    var result = [Int]()

    var ai = 0, bi = 0
    while ai < a.count && bi < b.count {
        if a[ai] <= b[bi] {
            result.append(a[ai])
            ai += 1
        } else {
            result.append(b[bi])
            bi += 1
        }
    }
    if ai < a.count {
        result += Array(a[ai..<a.count])
    } else {
        result += Array(b[bi..<b.count])
    }

    return result
}

func mergeSort(nums: [Int]) -> [Int]{
    if nums.count == 0 { return [Int]() }

    if nums.count == 1 { return nums }

    let mid = nums.count / 2
    var left = Array(nums[0..<mid])
    var right = Array(nums[mid..<nums.count])

    left = mergeSort(nums: left)
    right = mergeSort(nums: right)

    let result = merge(a: left, b: right)

    return result
}








/*
 快速排序：
 比较排序，原地排序，非稳定排序
 空间复杂度：仅需少量交换，O(n)
 时间复杂度：O(nlogn)，最差O(n^2)
 分治，递归。先找一个临界点，如最后一个元素，然后分治，把数组分为左右2部分，左边小于临界点，右边大于临界点，递归这个过程
 实际环境中，临界点的选取，一般是3数平均法等，并不是完全随机
 */

func quickSort(a: inout [Int]) {
    if a.count <= 1 { return }
    
    quickSort(a: &a, from: 0, to: a.count-1)
}
func quickSort(a: inout [Int], from low: Int, to high: Int) {
    if low >= high { return }
    
    let m = partition(a: &a, from: low, to: high)
    quickSort(a: &a, from: low, to: m-1)
    quickSort(a: &a, from: m+1, to: high)
}
func partition(a: inout [Int], from low: Int, to high: Int) -> Int {
    
    var i = low, j = low
    while j < high {
        if a[j] < a[high] {
            if i != j {
                a.swapAt(i, j)
            }
            i += 1
        }
        j += 1
    }
    a.swapAt(i, high)
    
    return i
}

var nums = [100, 200, 5,  500, 1, 99, 34, 10, 22, 999, 4]

//var nums = [100, 200, 5,  500, 1, 99, 34, 10, 22, 999, 1000, 1002, 1009, 1005, 1007]

//bubbleSort(a: &nums)
//bubbleSort1(a: &nums)
//insertSort(a: &nums)
selectSort(a: &nums)
//print(mergeSort(nums: nums))
//quickSort(a: &nums)
print(nums)
