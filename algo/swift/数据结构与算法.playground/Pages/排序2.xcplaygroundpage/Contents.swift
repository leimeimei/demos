

import Foundation

/*
 有桶排序、计数排序、基数排序
 3种线性时间复杂度，时间复杂度O(n)，不基于比较，对数据有要求，所以使用场景有限
 
 桶排序和计数排序的排序思想是非常相似的，都是针对范围不大的数据，将数据划分成不同的桶来实现排序。
 基数排序要求数据可以划分成高低位，位之间有递进关系。比较两个数，我们只需要比较高位，高位相同的
 再比较低位。而且每一位的数据范围不能太大，因为基数排序算法需要借助桶排序或者计数排序来完成每
 一个位的排序工作.
 */




/**
 桶排序：适合用在外部排序，数据量较大，无法全部加载到内存
 */




/**
 计数排序：O(n),非原地排序
 只能用在数据范围不大的场景，如果数据范围K比要排序的数据n大很多，就不适合用计数排序。而且，
 计数排序只能给非负整数排序。如果是其他类型，则要在不改变相对大小的情况下，转化为非负整数。
 */
func countSort(a: inout [Int]) {
    let count = a.count
    if count <= 1 { return }
    
    // 找最大数
    var maxValue = 0
    for i in 0..<count {
        maxValue = max(maxValue, a[i])
    }
    
    //计数
    var tmp = Array(repeating:0, count:maxValue+1)
    for i in 0..<count {
        tmp[a[i]] += 1
    }
    print(tmp)
    // 依次累加
    for i in 1...maxValue {
        tmp[i] += tmp[i-1]
    }
    print(tmp)
    // 核心：count[a[i] -1]就是排序好的下标
    var result = Array(repeating:0, count: count)
    var i = count - 1
    for i in (0...count-1).reversed() {
        result[tmp[a[i]] - 1] = a[i]
        tmp[a[i]] -= 1
    }
    // 赋值回去
    for i in 0..<count {
        a[i] = result[i]
    }

}




/**
 基数排序：对要排序的数据有要求，需要可以分割出独立的“位”来比较。而且位之间有递进的关系，如果a的数据的高位比b的数据大，那剩下的旧不用比较了。另外，每一位的数据范围不能太大，要可以用线性排序算法来排序，否则，基数排序的时间复杂度无法做到O(n)
 */










var a = [5,7,2,4,9,1,6]
countSort(a:&a)
print(a)
