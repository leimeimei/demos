//
//  PropertyWrapper.swift
//  ReaderExample
//
//  Created by sun on 2021/12/27.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }
}
