

import Foundation

public class Node<Int> {
    var data: Int?
    var next: Node?
    
    init() {}
    
    init(value: Int) {
        self.data = value
    }
}

class List<Element: Equatable> {
    var dummy = Node<Element>()
    
    // size的计算，如果只在增减节点的时候加减，赋值的新链表size为0
    // 如果此处遍历计算，遇到环的情况会死循环
    // 解决： 如果有环，找到环节点，计算头节点到环节点的长度，计算环的长度
    var size: Int {
        var size = 0
        let meetNode = checkCircle()
        if meetNode != nil {
            size = getRingLength(meetNode: meetNode!) + getLengthA(meetNode: meetNode!)
        } else {
            var current = dummy.next
            while current != nil {
                current = current?.next
                size += 1
            }
        }
        
        return size
    }
    
    var isEmpty: Bool { return size == 0 }
    
    func node(with value: Element) -> Node<Element>? {
        var node = dummy.next
        while node != nil {
            if node!.data == value {
                return node
            }
            node = node!.next
        }
        return nil
    }
    
    func node(at index: Int) -> Node<Element>? {
        var num = 1
        var node = dummy.next
        while node != nil {
            if num == index {
                return node
            }
            node = node!.next
            num += 1
        }
        
        return nil
    }
    
    func insertToHead(value: Element) {
        let newNode = Node(value: value)
        insertToHead(node: newNode)
    }
    func insertToHead(node: Node<Element>) {
        node.next = dummy.next
        dummy.next = node
    }
    
    func insert(after node: Node<Element>, newValue: Element) {
        let newNode = Node(value: newValue)
        insert(after: node, newNode: newNode)
    }
    func insert(after node: Node<Element>, newNode: Node<Element>) {
        newNode.next = node.next
        node.next = newNode
    }
    
    func insert(before node: Node<Element>, newValue: Element) {
        let newNode = Node(value: newValue)
        insert(before: node, newNode: newNode)
    }
    func insert(before node: Node<Element>, newNode: Node<Element>) {
        var lastNode = dummy
        var tmpNode = dummy.next
        while tmpNode != nil {
            if tmpNode === node {
                newNode.next = tmpNode
                lastNode.next = newNode
            }
            lastNode = tmpNode!
            tmpNode = tmpNode?.next
        }
    }
    
    func delete(node: Node<Element>) {

        var lastNode = dummy
        var tmpNode = dummy.next
        while tmpNode != nil {
            if tmpNode === node {
                lastNode.next = tmpNode!.next
                break
            }
            lastNode = tmpNode!
            tmpNode = tmpNode!.next
        }
    }
    
    func delete(value: Element) {

        var lastNode = dummy
        var tmpNode = dummy.next
        while tmpNode != nil {
            if tmpNode!.data == value {
                lastNode.next = tmpNode!.next
                break
            }
            lastNode = tmpNode!
            tmpNode = tmpNode?.next
        }
    }
    
    func printList() {
        var tmp = dummy.next
        while tmp != nil {
            print(tmp!.data!)
            tmp = tmp?.next
        }
    }
    // 单链表翻转
    func reverse() {

        var prev: Node<Element>? = nil
        var current = dummy.next
        while current != nil {
            let next = current?.next
            if next == nil {
                dummy.next = current!
            }
            current?.next = prev
            prev = current
            current = next
        }
    }
    
    // 找中间节点
    func findMid() -> Node<Element>? {
        
        var slow = dummy.next, fast = dummy.next
        while fast != nil && fast?.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
        }
        
        return slow
    }
    
    // 验证是否有环
    func checkCircle() -> Node<Element>? {
        
        var slow = dummy.next, fast = dummy.next
        while fast != nil && fast?.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
            if slow === fast {
                return fast
            }
        }
        return nil
    }
    
    // 如果有环， 获取环的长度
    func getRingLength(meetNode: Node<Element>) -> Int {
        
        var length = 0
        var fast: Node<Element>? = meetNode
        var slow: Node<Element>? = meetNode
        while true {
            fast = fast?.next?.next
            slow = slow?.next
            length += 1
            if fast === slow {
                break
            }
        }
        
        return length
    }
    
    // 如果有环，获取头节点到环节点的长度
    func getLengthA(meetNode: Node<Element>) -> Int {
        
        var length = 0
        var fast = dummy.next
        let slow: Node<Element>? = meetNode
        while fast !== slow {
            fast = fast?.next
            length += 1
        }
        
        return length
    }
    
}


/*链表是否有环*/
func testCircle() {
    let list = List<Int>()
    let node5 = Node(value: 5)
    let node4 = Node(value: 4)
    let node3 = Node(value: 3)
    let node2 = Node(value: 2)
    let node1 = Node(value: 1)
    list.insertToHead(node: node5)
    list.insertToHead(node: node4)
    list.insertToHead(node: node3)
    list.insertToHead(node: node2)
    list.insertToHead(node: node1)
    
    list.checkCircle() != nil ? print("circle") : print("no circle")
    
    node5.next = node1;
    
    list.checkCircle() != nil ? print("circle") : print("no circle")
    
    print(list.size)
    
}

/** 有序链表合并 */
func moveNode(dest node: inout Node<Int>?, src: inout Node<Int>?) {
    if src == nil {
        return
    }
    let newNode = src!
//    print(src!.data!)
    src = newNode.next
    newNode.next = node
    node = newNode
}

func combine(list1: List<Int>, list2: List<Int>) -> List<Int> {
    let first = List<Int>();
    var tail = Node<Int>()
    first.dummy = tail

    while true {
        if list1.dummy.next == nil {
            tail.next = list2.dummy.next
            break
        } else if list2.dummy.next == nil {
            tail.next = list1.dummy.next
            break
        }
        if  let v1 = list1.dummy.next?.data,
            let v2 = list2.dummy.next?.data,
            v1 <= v2 {
            moveNode(dest: &(tail.next), src: &list1.dummy.next)
        } else {
            moveNode(dest: &(tail.next), src: &list2.dummy.next)
        }
        tail = tail.next!
    }
    
    return first
}

func testCombine () {
    let list1 = List<Int>()
    let list2 = List<Int>()
    let node7 = Node(value: 50)
    let node6 = Node(value: 10)
    let node5 = Node(value: 5)
    let node4 = Node(value: 4)
    let node3 = Node(value: 3)
    let node2 = Node(value: 2)
    let node1 = Node(value: 1)
    list2.insertToHead(node: node7)
    list2.insertToHead(node: node6)
    list1.insertToHead(node: node5)
    list2.insertToHead(node: node4)
    list1.insertToHead(node: node3)
    list2.insertToHead(node: node2)
    list1.insertToHead(node: node1)
    
    
    let list = combine(list1: list1, list2: list2)
    list.printList()
}

/*翻转单链表*/
func testReverse() {
    let list = List<Int>()
    let node5 = Node(value: 5)
    let node4 = Node(value: 4)
    let node3 = Node(value: 3)
    let node2 = Node(value: 2)
    let node1 = Node(value: 1)
    list.insertToHead(node: node5)
    list.insertToHead(node: node4)
    list.insertToHead(node: node3)
    list.insertToHead(node: node2)
    list.insertToHead(node: node1)
    
    list.reverse()
    list.printList()
}


/*删除倒数第K个节点*/
func deleteK(list: List<Int>, k: Int) {
    if list.dummy.next == nil || k == 0 {
        return
    }
    // 快指针向前移动 k-1
    var fast = list.dummy.next
    var i = 1
    while i < k && fast != nil {
        fast = fast?.next
        i += 1
    }
    // 如果快指针为空，说明结点个数小于 k
    if fast == nil {
        return
    }
    
    var slow = list.dummy.next
    var prev: Node<Int>?
    while fast?.next != nil {
        fast = fast?.next
        prev = slow
        slow = slow?.next
    }
    if prev == nil {
        list.dummy = list.dummy.next!
    } else {
        prev?.next = slow?.next
    }
}

func testDeleteK() {
    let list = List<Int>()
    let node5 = Node(value: 5)
    let node4 = Node(value: 4)
    let node3 = Node(value: 3)
    let node2 = Node(value: 2)
    let node1 = Node(value: 1)
    list.insertToHead(node: node5)
    list.insertToHead(node: node4)
    list.insertToHead(node: node3)
    list.insertToHead(node: node2)
    list.insertToHead(node: node1)
    
    deleteK(list: list, k: 5)
    list.printList()
}

/*使用链表做按位进制加法*/
func binaryAdd(list: List<Int>, plus aList: List<Int>) -> List<Int> {
    
    if list.size == 0 { return aList }
    if aList.size == 0 { return list }
    
    let res = List<Int>()
    var pre: Node<Int>?
    res.dummy.next = pre
    
    var headA = list.dummy.next
    var headB = aList.dummy.next
    
    var c = 0 // 进位
    // 按位相加
    while headA != nil && headB != nil {
        let t = headA!.data! + headB!.data!
        let newNode = Node(value: t % 10)
        if pre != nil {
            pre?.next = newNode
            pre = newNode
        } else {
            res.dummy.next = newNode
            pre = newNode
        }
        c = t / 10
        headA = headA?.next
        headB = headB?.next
    }
    while headA != nil {
        let t = headA!.data! + c
        let newNode = Node(value: t % 10)
        pre?.next = newNode
        pre = newNode
        c = t / 10
        headA = headA?.next
    }
    while headB != nil {
        let t = headB!.data! + c
        let newNode = Node(value: t % 10)
        pre?.next = newNode
        pre = newNode
        c = t / 10
        headB = headB?.next
    }
    if c > 0 {
        let newNode = Node(value: c)
        pre?.next = newNode
    }
    
    return res
}

func testAdd() {
    let list1 = List<Int>()
    let list2 = List<Int>()
    let node5 = Node(value: 5)
    let node4 = Node(value: 4)
    let node3 = Node(value: 3)
    let node2 = Node(value: 2)
    let node1 = Node(value: 1)
    list1.insertToHead(node: node5)
    list2.insertToHead(node: node4)
    list1.insertToHead(node: node3)
    list2.insertToHead(node: node2)
    list1.insertToHead(node: node1)
    
    
    list1.reverse()
    list2.reverse()
    
    let res = binaryAdd(list: list1, plus: list2)
    res.reverse()
    res.printList()
    print(res.size)
    
}

//testCircle()
testCombine()
//testReverse()
//testDeleteK()
//testAdd()




