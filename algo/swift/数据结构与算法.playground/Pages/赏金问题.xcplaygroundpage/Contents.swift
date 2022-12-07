

import Foundation


// 赏金问题
func rewards(total: Int, reward: [Int], res: inout [Int]) {

    if total == 0 {

        print(res)
        return
    } else if total < 0 {
        return
    } else {

        for i in 0 ..< reward.count {

            var newResult  = res
            newResult.append(reward[i])
            rewards(total: total - reward[i], reward: reward, res: &newResult)
        }
    }
}
let reward = [1,2,5,10]
var res: [Int] = []
rewards(total:10, reward: reward, res: &res)


// 分解整数
func resursion(total: Int, res: inout [Int]) {
    if total == 1 {
        if !res.contains(1) {
            res.append(1)
        }
        print(res)
        return
    } else {
        for i in 1...total {
            if i == 1 && res.contains(1) { continue }

            var newList = res
            newList.append(i)
            if total % i != 0 {
                continue
            }
            resursion(total: total / i, res: &newList)
        }
    }
}

var result: [Int] = []
resursion(total: 8, res: &result)
