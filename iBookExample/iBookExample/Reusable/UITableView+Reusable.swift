//
//  UITableView+Reusable.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import Foundation
import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) where T: NibReusable {
        self.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
        self.register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                       + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                       + "and that you registered the cell beforehand")
        }
        return cell
    }
    func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) where T: NibReusable {
        self.register(headerFooterViewType.nib, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }
    func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) where T: Reusable {
        self.register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T? where T: Reusable {
        
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T? else {
            
            fatalError(
                "Failed to dequeue a header/footer with identifier \(viewType.reuseIdentifier) "
                    + "matching type \(viewType.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the header/footer beforehand"
            )
        }
        return view
    }
}
