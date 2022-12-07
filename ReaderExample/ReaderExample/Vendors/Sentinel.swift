//
//  Sentinel.swift
//  ReaderExample
//
//  Created by sun on 2021/12/27.
//

import Foundation

struct Sentinel {
    private var _value: Int = 0
    
    private mutating func _valuePtr() -> UnsafeMutablePointer<Int> {
        withUnsafeMutablePointer(to: &_value) { (ptr) -> UnsafeMutablePointer<Int> in
            return ptr
        }
    }
    
    init(value: Int = 0) {
        self._value = value
    }
    
    @discardableResult
    mutating func value() -> Int {
        _swift_stdlib_atomicLoadInt(object: _valuePtr())
    }
    
    @discardableResult
    mutating func increase() -> Int {
        _swift_stdlib_atomicFetchAddInt(object: _valuePtr(), operand: 1)
    }
}
