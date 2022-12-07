//
//  BubbleSort1.swift
//  Sorting
//
//  Created by sun on 2019/10/10.
//  Copyright © 2019 sun. All rights reserved.
//

import Cocoa

/*
    时间复杂度 o(n^2)
 */

class BubbleSort1: Sort {
    
    override func sort() {
        for end in (1...array.count-1).reversed() {
            for begin in (1...end) {
                if cmp(i1: begin, i2: begin-1) {
                    swap(i1: begin, i2: begin-1)
                }
            }
        }
    }
}
