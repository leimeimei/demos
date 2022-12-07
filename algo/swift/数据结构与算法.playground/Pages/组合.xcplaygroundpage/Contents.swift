

import Foundation


// 组合
// C(n,m) = n! / (n-m)! / m!

func combine(teams: [String], res: [String], count: Int) {
    if res.count == count {
        print(res)
        return
    }
    
    for i in 0..<teams.count {
        var newList = res
        newList.append(teams[i])
        var restList = Array(teams[(i+1)...])
        combine(teams:restList, res:newList, count:count)
    }
}
let teams = ["a", "b", "c", "d", "e"]
combine(teams: teams, res: [String](), count: 2)

