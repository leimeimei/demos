//
//  Student.swift
//  Sorting
//
//  Created by sun on 2019/10/10.
//  Copyright © 2019 sun. All rights reserved.
//

import Foundation

public class Student: Comparable {
    
    public var score: Int
    public var age: Int
    public init(score: Int, age: Int) {
        self.score = score
        self.age = age
    }

    public static func < (lhs: Student, rhs: Student) -> Bool {
        if lhs.age < rhs.age { return true }
        return false
    }
    
    public static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs.age == rhs.age
    }
}
