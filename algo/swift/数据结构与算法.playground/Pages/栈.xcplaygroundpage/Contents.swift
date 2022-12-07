
import Foundation


// 汉诺塔
func hanoi(n: Int, x: String, y: String, z: String) {
    if n != 0 {
        hanoi(n:n-1,x:x,y:z,z:y)
        print(x + "->" + y)
        hanoi(n:n-1,x:z,y:y,z:x)
    }
}

hanoi(n:4,x:"a",y:"b",z:"c")
