

import Foundation


let strValue2 = "123"
let intValue2 = Int(strValue2)

let flags = "99_problems"
flags.unicodeScalars.map {
    print("\(String($0.value, radix: 16, uppercase: true))")
}
