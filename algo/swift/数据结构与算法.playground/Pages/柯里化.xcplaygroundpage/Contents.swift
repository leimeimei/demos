import UIKit


func add(adder :Int) -> ((Int) -> Int) {
    return {num in
        return num + adder
    }
}

let a = add(adder: 2)

let b = a(3)

let c = a(6)


func greaterThan(_ compare: Int) -> (Int) -> Bool {
    return { $0 > compare }
}

let e = greaterThan(10)

let f = e(6)



// swift中默认参数为let，不能修改
//func errorFunc( num :var Int) -> Int {
//    num += 1
//    return num
//}
func incrementor(variable: inout Int) -> Int {
    variable += 1
    return variable
}

var h = 5
let i = incrementor(variable: &h)



var j: [Int] = NSMutableArray() as! [Int]
j.append(1)
j.append(2)
print(j)


// 字典取出的值为可选值
let k = ["1" :"a"]
let l: String? = k["2"]






