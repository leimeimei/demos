

import Foundation

// swift中使用键盘输入数字，playground中无效
func inputANumber() -> Int? {
    print("input:")
    let sin = FileHandle.standardInput
    var cx = String(data: sin.availableData, encoding: .utf8) as NSString?
    cx = cx?.replacingOccurrences(of: "\n", with: "") as NSString?
    return Int((cx as String?)!)
}


class TreeNode<Element> {
    var data: Element
    var lchild: TreeNode?
    var rchild: TreeNode?
    
    init(value: Element) {
        self.data = value
    }
}

// 前序遍历
func preOrder(root: TreeNode<Int>?) {
    if root == nil { return }
    
    print(root!.data)
    preOrder(root: root?.lchild)
    preOrder(root: root?.rchild)
}
// 中序遍历
func midOrder(root: TreeNode<Int>?) {
    if root == nil { return }
    
    preOrder(root: root?.lchild)
    print(root!.data)
    preOrder(root: root?.rchild)
}
// 后序遍历
func postOrder(root: TreeNode<Int>?) {
    if root == nil { return }
    
    preOrder(root: root?.lchild)
    preOrder(root: root?.rchild)
    print(root!.data)
}


///////////////////////////////////////////////
// 二叉查找树要求，在树中的任意一个节点，其左子树中的每个节点的每个节点的值
// 都要小于这个节点的值，而右子树节点的值都大于这个节点的值
///////////////////////////////////////////////


// 二叉查找树 - 查找
func findNode(data: Int, tree: TreeNode<Int>?) -> TreeNode<Int>? {
    var node = tree
    
    while node != nil {
        if data < node!.data {
            node = node!.lchild
        } else if data > node!.data {
            node = node!.rchild
        } else {
            return node!
        }
    }
    return nil
}


// 二叉查找树 - 插入
func insertNode(data: Int, tree: inout TreeNode<Int>?) {
    if tree == nil {
        tree = TreeNode(value: data)
        return
    }
    
    var node = tree
    
    while node != nil {
        if data > node!.data {
            if node?.rchild == nil {
                node?.rchild = TreeNode(value: data)
                return
            }
            node = node?.rchild
        } else {
            if node?.lchild == nil {
                node?.lchild = TreeNode(value: data)
                return
            }
            node = node?.lchild
        }
    }
}



// 二叉查找树 - 删除
func deleteNode(data: Int, tree: inout TreeNode<Int>?) {
    var p: TreeNode? = tree // p 指向要删除的节点
    var pp: TreeNode<Int>? // p的父节点
    while p != nil && p?.data != data {
        pp = p
        if data > p!.data {
            p = p?.rchild
        } else {
            p = p?.lchild
        }
    }
    if p == nil { return } // 没有找到要删除的节点
    
    // 如果要删除的节点有2个子节点
    if p?.lchild != nil && p?.rchild != nil {
        var minP = p?.rchild   // 在右子树中找最小点
        var minPP = p  // minP的父节点
        while minP?.lchild != nil {
            minPP = minP
            minP = minP?.lchild
        }
        p!.data = minP!.data  // 将minP的数据替换到p中
        
        p = minP        // 替换，下面删除p，其实就是minP
        pp = minPP
    }
    
    // 删除节点是叶子节点 或者仅有一个子节点
    // 如果是2个子节点，上面已经找到了右树最小节点，这里的p其实是minP
    var child: TreeNode<Int>?
    if p?.lchild != nil {
        child = p?.lchild
    } else if p?.rchild != nil {
        child = p?.rchild
    } else {
        child = nil
    }
    
    // 如果是2个子节点，上面已经找到了右树最小节点，这里的pp其实是minPP
    if pp == nil {
        tree = child // 删除的是根节点
    } else if pp?.lchild === p {
        pp?.lchild = child
    } else {
        pp?.rchild = child
    }
    
}

var node: TreeNode? = TreeNode(value: 2)
insertNode(data: 3, tree: &node)
insertNode(data: 1, tree: &node)
midOrder(root: node)
deleteNode(data: 3, tree: &node)
midOrder(root: node)
