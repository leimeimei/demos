

import Foundation


public struct MyArray<Element> {
    private var data: [Element]
    private var capacity = 0
    private var count = 0
    
    init(defaultElement: Element, capacity: Int) {
        data = [Element](repeating: defaultElement, count: capacity)
        self.capacity = capacity
    }
    
    func find(at index: Int) -> Element? {
        guard index >= 0, index < count else {
            return nil
        }
        return data[index]
    }
    
    mutating func delete(at index: Int) {
        guard index >= 0, index < count else {
            print("out of range!")
            return
        }
        for i in index..<count-1 {
            data[i] = data[i+1]
        }
        count -= 1
    }
    
    mutating func insert(obj: Element, at index: Int) {
        guard index >= 0, index < count, count < capacity else {
            print("out of range!")
            return
        }
        for i in (index...index-1).reversed() {
            data[i+1] = data[i]
        }
        data[index] = obj
        count += 1
    }
    
    mutating func add(obj: Element) {
        guard count < capacity else {
            print("out of range!")
            return
        }
        data[count] = obj
        count += 1
    }
    
    func size() -> Int {
        return count
    }
    
    func show() {
        for i in 0..<count {
            print(data[i])
        }
    }
}

var arr = MyArray(defaultElement: 0, capacity: 3)
arr.show()
arr.add(obj: 1)
arr.show()
arr.delete(at: 1)

