import UIKit

//func re(number: Int) -> Int {
//    var numberShadow: Int = 0
//    var result: Int = 0
//
//    numberShadow = number
//    while true {
//        result = result * 10 + numberShadow % 10
//        numberShadow = numberShadow / 10
//        if numberShadow == 0 {
//            break
//        }
//    }
//    return result
//}
//
//re(number: 123)
//
//func abc(nums: Int..., values: Double...) {
//
//}
//
//var sum: (Int, Int) -> Int = { $0 + $1 }
//
//sum(1, 2)
//
//
//struct ABC {
//    var from: Int = 0
//    var to: Int = 0
//
//    func callAsFunction(step: Int) -> Int {
//        var total = 0
//        for i in stride(from: from, to: to, by: step) {
//            total = total + i
//        }
//        return total
//    }
//}
//
//var result = ABC(from: 1, to: 10)
//result(step: 1)


//struct ABC {
//    var age: Int
//}
//
//var arr = [ABC(age: 1),ABC(age: 2),ABC(age: 3)]
//print(arr)
//var mid = arr[1]
//mid.age = 0
//print(arr)
//[arr .replaceSubrange(Range(NSMakeRange(1, 1))!, with: [mid])]
//print(arr)

class ABC<T> {
    var abc: T
    init(abc:T) {
        self.abc = abc
    }
}
var a = ABC(abc: 10)
print(a.abc)

var b = ABC(abc: "abc")
print(b.abc)

protocol CDE {
    associatedtype T
    
    func myPrint()
}

extension CDE {
    func myPrint() {
        print(T.self)
    }
}

class FF: CDE {
    typealias T = String
}
FF().myPrint()

class EE: CDE {
    typealias T = Int
}
EE().myPrint()

class DD<E> :CDE {
    typealias T = E
    
}
DD<Double>().myPrint()

func mid<A: CDE>(a: A) {
    a.myPrint()
}

mid(a: DD<Int>())
