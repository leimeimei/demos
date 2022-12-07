

import Foundation

let str1 = "abcde"
let str2 = "fgh"
print(str1) // prints 'abcde'
print(str2) // prints 'fgh'
let str1Count = str1.count
let str2Count = str2.count
let result = zip(str1,str2).reduce(into: "") {
    $0.append($1.0)
    $0.append($1.1)
    } + ( str1Count > str2Count ?
        str1.suffix(str1Count-str2Count) :
        str2.suffix(str2Count-str1Count) )

print(result) // 'afbgchde'




func isUnique(str: String) -> Bool {
    var check = 0
    for char in str.utf8 { // 字符串转ascii码数组
        
        let v = UInt32(char) - UnicodeScalar("a").value
        
        // 这种写法也行
        //        let v = UInt32(char) - ("a".unicodeScalars.first?.value)!
        
        if (check & (1 << v)) == 1 {
            return false
        }
        check |= (1 << v)
    }
    return true
}

print(isUnique(str: "abca"))

func trans() {
    let flags = "99_problems"
    flags.unicodeScalars.map {
        print("\(String($0.value, radix: 16, uppercase: true))")
    }
}
trans()

