

import Foundation

// 利用递归枚举
typealias Op = (Int, Int) -> Int

indirect enum Node {
    case value(Int)
    case op(Op, Node, Node)
    
    func evaluate() -> Int {
        switch self {
        case .value(let v):
            return v
        case .op(let op, let left, let right):
            return op(left.evaluate(), right.evaluate())
        }
    }
}

extension Node: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self = .value(value)
    }
}

let root: Node = .op(*, 2, .op(/, 3, 1))
print(root.evaluate())




//逆波兰表达式
/*
 将中缀表达式变为后缀表达式，需要一个栈SOP和一个线性表L。SOP用于临时存储运算符和分界符号，如（），L用于存储后缀表达式。
 
 遍历原始表达式的每一个表达式元素：
 1- 如果是操作数，直接追加到L中。只有运算符或者分解符（）才可以放到SOP中；
 2- 如果是分界符：
    1- 如果是左括号，直接h压入SOP，等待下一个最近的右括号与之匹配
    2- 如果是右括号，则说明已经有一对括号可以配对。不压栈，直接丢弃右括号，然后从SOP中出栈，得到s元素e，将e依次追加到L中，一直循环到左括号，同样丢弃。
 3- 如果是运算符，用op1标示
    1- 如果SOP栈顶元素（用op2）标示，不是运算符，二者没有可比性，直接将op1压栈。例如栈顶是左括号或者栈为空。
    2- 如果SOP栈顶元素（op2）是运算符，则比较op1和op2的优先级。如果op1 > op2， 则直接将op1压栈。
 如果不满足op1 > op2，则将op2出栈，并追加到L，重复步骤3.
 也就是说如果SOP中，相邻两个元素都是运算符，必须满足，下层运算符的优先级一定小于上层优先级，才能相邻。
 
 如果最后SOP中还有元素，依次弹出SOP，并追加到L,结果即为后缀表达式。
 */

// 利用栈
public struct Stack<E> {
    private var arr = [E]()
    public mutating func pop() -> E {
        let last = arr.last!
        arr.remove(at: arr.count - 1)
        return last
    }
    public mutating func push(_ obj: E) {
        arr.append(obj)
    }
}

func testReversePolishNotation(_ arr: [String]) {
    var stack = Stack<Int>()
    for c in arr {
        switch c {
        case "+": stack.push(stack.pop() + stack.pop())
        case "-": stack.push(-stack.pop() + stack.pop())
        case "*": stack.push(stack.pop() * stack.pop())
        case "/":
            let right = stack.pop()
            stack.push(stack.pop() / right)
            
        default:
            stack.push(Int(c)!)
        }
    }
    print(stack.pop())
}

var expr = ["2","5","*","2","+","2","/"]
testReversePolishNotation(expr)
