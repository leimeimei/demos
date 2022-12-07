

import Foundation

// 二分求近似平方根
func squar(a: Double, thread: Double, maxTry: Int) -> Double {
    if a < 0 {
        return -1.0
    }

    var min = 1.0, max = a
    for _ in 1..<maxTry {
        let mid = min + (max - min) / 2
        let squar = mid * mid
        if fabs(squar - a) < thread {
            return mid
        } else if squar > a {
            max = mid
        } else {
            min = mid
        }
    }
    return -1.0
}

let res = squar(a: 25.0, thread: 0.1, maxTry: 100)

let c = sqrt(25.0)
