//
//  main.swift
//  swiftDemo
//
//  Created by sun on 2021/10/14.
//

import Foundation
struct Person {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

func test() {
    let p1 = Person(name: "p1", age: 1)
    let p2 = Person(name: "p2", age: 2)
    let arr = [p1, p2]
    var p: Person = arr[1]
    p.age = 3
    for p in arr {
        print("name:" + p.name + " ===" + " age:" + String(p.age))
    }
}

test()

var click: ((_ id: String) -> Int)

click = { id in
    print("id:\(id)")
    return 3
}

let a = click("123")
print(a)


