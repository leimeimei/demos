

import Foundation

// 位运算比较
func compare1() {
    var even = 0, odd = 0
    for i in 0..<100000 {
        if (i & 1) == 0 {
            even += 1
        } else {
            odd += 1
        }
    }
}

func compare2() {
    var even = 0, odd = 0
    for i in 0..<100000 {
        if (i % 2) == 0 {
            even += 1
        } else {
            odd += 1
        }
    }
}

//var date = Date()
//compare1()
//print(Date().timeIntervalSince(date))
//date = Date()
//compare2()
//print(Date().timeIntervalSince(date))



/////////////////////////////////////////////////////

// 位运算求2个数组中重复的数字
// 把每个数组中的所有数字先异或位运算，然后把2个结果再异或位运算，得到重复的数字
// 原理： x ^ x = 0
// 只能求出所有重复次数为奇数的情况，重复次数为偶数则不行
var a = [1,2,3,6]
var b = [1,2,2,3,6]
var c = a.reduce(0) { result, n in
    return n ^ result
}
var d = b.reduce(0) { result, n in
    return n ^ result
}
let result = c ^ d


/////////////////////////////////////////////////////////

// 判断回文数
// 如果是回文数，个数为偶数的话，所有值异或结果为0，因为每个数字出现2次
// 如果为个数为奇数，则中间的数字就是最后异或结果，比较一下相等则是，否则不是
func testHuiWen() {
    let f = [1,2,5,3,4,3,5,2,1]
    let value = f.reduce(0) { result, n in
        return n ^ result
    }
    var res = false
    if (f.count & 1) == 0 {// even
        if value == 0 {
            res = true
        }
    } else { // odd
        if value == f[f.count / 2] {
            res = true
        }
    }
    res ? print("YES") : print("false")
}

// 数学方法判断是否是回文数
func isPalindromeNum(num: Int) -> Bool {
    if num < 0 {
        return false
    } else if num == 0 {
        return true
    } else {
        var tmp = num
        var y = 0
        while tmp != 0 {
            y = y * 10 + tmp % 10
            tmp = tmp / 10
        }
        return y == num
    }
}
//print(isPalindromeNum(num: 1212))

//testHuiWen()


///////////////////////////////////////////////////////////

// 判断字符是否重复
func isUnique(str: String) -> Bool {
    var check = 0

    for char in str.utf8 {
//        let v = UInt32(char) - ("a".unicodeScalars.first?.value)!
        let v = UInt32(char) - UnicodeScalar("a").value
        if (check & (1 << v)) == 1 {
            return false
        }
        check |= (1 << v)
    }
    
    return true
}
//print(isUnique(str: "abcaaaac"))



/////////////////////////power of two/////////////////////////////////

//如果是2的幂，那么这个数的二进制形式只可能有一个1，如果出现2个或者以上，证明不是2的幂
//负数不能这样判断
func isPowerOfTwo(num: Int) -> Bool {
    var tmp = num  // 防止修改
    assert(num > 0, "number must be greater than zero")
    
    var hasOne = false
    while tmp > 0 {
        if tmp & 1 == 1 {
            hasOne = hasOne ? false : true
        }
        tmp = tmp >> 1
    }
    return hasOne
}
// 正数
func isPowerOfTwo2(num: Int) -> Bool {
    var tmp = num  // 防止修改
    assert(num > 0, "number must be greater than zero")
    
    var count1 = 0 // 直接计算1的个数
    while tmp > 0 {
        if tmp & 1 == 1 {
            count1 += 1
        }
        tmp = tmp >> 1
    }
    return count1 == 1  // 不等于1就不是2的幂
}

//print(isPowerOfTwo2(num:128))



////////////////////////////missing number/////////////////////////////////

//从0到n之间取出n个不同的数，找出漏掉的那个,要注意0的情况
//[0,1,3]
// 求和
func findNum(array: [Int], n: Int) -> Int {
    
    let sum1 = array.reduce(0) { res, i in return res + i }
    var sum2 = 0
    for i in 0...n {
        sum2 += i
    }
    return sum2 - sum1
}
// 异或
func findNum1(array: [Int], n: Int) -> Int {
    let res1 = array.reduce(0) { res, i in return res ^ i }
    var res2 = 0
    for i in 0...n {
        res2 = res2 ^ i
    }
    return res2 ^ res1
}

let arr = [1,2,3,5,6]

print(findNum(array: arr, n: 6))
print(findNum1(array: arr, n: 6))

