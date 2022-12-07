
import Foundation
// 使用队列解决击鼓传花游戏，每次接到花的出局，求最后留下的一个是第几个
class myQueue {
    
    private var data = Array<String>()
    
    var size: Int {
        return data.count
    }
    
    func append(name: String) {
        data.append(name)
    }
    
    func shift() -> String? {
        if data.count > 0 {
            let res = data.first
            data.remove(at: 0)
            return res
        }
        return nil
    }
    
    func front() -> String? {
        return data.first
    }
    
    func isEmpty() -> Bool {
        return data.count == 0
    }
    
}

func test() {
    var peopleArr = [String]()
    var queue = myQueue()
    let count = 10
    let outNum = 17
    for i in 0..<count {
        let str = String(format: "people%ld", i)
        peopleArr.append(str)
        queue.append(name: str)
    }
    
    while queue.size > 1 {
        for _ in 0..<outNum {
            queue.append(name: queue.shift()!)
        }
        queue.shift()
    }
    
    print(peopleArr.firstIndex(of: queue.front()!)!)
}

test()

