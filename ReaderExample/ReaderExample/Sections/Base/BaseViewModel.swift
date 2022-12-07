//
//  BaseViewModel.swift
//  ReaderExample
//
//  Created by sun on 2021/12/30.
//

import Foundation

class BaseViewModel {
    enum CallbackResult {
        case success
        case failure
    }
    enum CallbackDataResult<T> {
        case success(T)
        case failure
    }
}
