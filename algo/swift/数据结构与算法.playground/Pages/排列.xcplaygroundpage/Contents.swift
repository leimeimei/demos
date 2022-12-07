

import Foundation

// 排列  p(n,m) = n! / (n-m)!   全排列 p = n！

// 模拟暴力破解密码
let pwd = ["b", "e", "c", "d"]
let letter = ["a", "b", "c", "d", "e"]

func permutation(len: Int, res: [String]) {
    if len == 0 {
        if res == pwd {
            print(res)
            print("success")
        }
        return
    }
    for i in 0..<letter.count {
        var newList = res
        newList.append(letter[i])
        permutation(len: len-1,res: newList)
    }
}
let res = [String]()
permutation(len:pwd.count,res:res)
