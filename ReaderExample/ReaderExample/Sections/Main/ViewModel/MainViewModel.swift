//
//  MainViewModel.swift
//  ReaderExample
//
//  Created by sun on 2021/12/31.
//

import Foundation

class MainViewModel: BaseViewModel {
    var loadBookCallback: ((CallbackResult) -> Void)?
    var dataList: [BookModel]?
    
    func loadBookList() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.dataList = Database.shared.loadBookList()
            DispatchQueue.main.async {
                self.loadBookCallback?(.success)
            }
        }
    }
}
