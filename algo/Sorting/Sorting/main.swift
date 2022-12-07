//
//  main.swift
//  Sorting
//
//  Created by sun on 2019/10/10.
//  Copyright © 2019 sun. All rights reserved.
//

import Foundation


func testSorts(array: [Int], sorts: Sort...) {
    
    for sort in sorts {
        var arr = array
        arr = sort.sort(arr: arr)
        assert(isAscOrder(array: arr))
    }
    
    let sorted = sorts.sorted()
    
    for sort in sorted {
        print(sort.toString())
    }
}

var arr = random(min: 1, max: 2000, count: 1000)
//var arr = tailAscOrder(min: 0, max: 1000, disOrderCnt: 100)
//var arr = ascOrder(min: 0, max: 10000)

testSorts(array: arr, sorts:BubbleSort3(),
                            SelectionSort(),
                            HeapSort(),
                            InsertionSort3())


