

import Foundation

// 求第N项
func getN11(n: Int) -> Int {
    assert(n >= 0)
    
    if n == 0 {
        return 0
    } else if n == 1 {
        return 1
    } else {
        var i = 2
        var first = 0
        var second = 1
        var third = 0
        while i <= n {
            third = first + second
            first = second
            second = third
            i += 1
        }
        return third
    }
}

func getN2(n: Int) -> Int {
    var a = (0, 1)
    var i = 0
    while i < n {
        a = (a.1, a.0 + a.1)
        i += 1
    }
    return a.0
}

//print(getN1(n:6))
//print(getN2(n:7))


/////////////////////////////////////////////
// 求N项数组
func getFibonacciArray(n: Int) -> [Int] {
    assert(n >= 1)
    var res = Array(repeating:0, count:n)
    if n - 1 == 0 {
        res[0] = 1
    } else if n-1 == 1{
        res[0] = 1
        res[1] = 1
    } else {
        res[0] = 1
        res[1] = 1
        var i = 2
        while i <= n-1 {
            res[i] = res[i-1] + res[i-2]
            i += 1
        }
    }
    return res
}


func getFibonacciArray1(n: Int) -> [Int] {
    assert(n >= 1)
    var res = [Int]()
    var a = (0,1)
    var i = 0
    while i < n {
        a = (a.1, a.0 + a.1)
        res.append(a.0)
        i += 1
    }
    return res
}

print(getFibonacciArray1(n:7))


/////元组的特性使用示例
// swift中，元组可以比较大小，类似字符串，逐个比较

let a = (1, 20)
let b = (2, 3)
print( a < b)

// 计算星座
let zodiacName = ["摩羯座", "水瓶座", "双鱼座", "白羊座", "金牛座", "双子座",
                  "巨蟹座", "狮子座", "处女座", "天秤座", "天蝎座", "射手座"]
let zodiacDays = [(1, 20), (2, 19), (3, 21), (4, 21), (5, 21), (6, 22),
                  (7, 23), (8, 23), (9, 23), (10, 23), (11, 23), (12, 23)]

let birthday = (5, 1)

let result = zodiacDays.filter { $0 <= birthday }


if result.count == 0 {// 小于1月20号的情况
    print(zodiacName.last!)
} else {
    let index = (result.count - 1) % 12
    print(zodiacName[index])
}

