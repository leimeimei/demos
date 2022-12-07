//
//  BaseTabbarViewController.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import UIKit

class BaseTabBar: UITabBar {}

class BaseTabBarController: UITabBarController {
    enum Tabs {
        case book
        case history
        
        var selectedImage: UIImage {
            switch self {
            case .book:
                 return UIImage(systemName: "book.fill")!.withRenderingMode(.alwaysOriginal)
            case .history:
                return UIImage(systemName: "doc.fill")!.withRenderingMode(.alwaysOriginal)
            }
        }
        
        var unSelectedImage: UIImage {
            switch self {
            case .book:
                return UIImage(systemName: "book")!.withRenderingMode(.alwaysOriginal)
            case .history:
                return UIImage(systemName: "doc")!.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    static func tabBarController() -> BaseTabBarController {
        BaseTabBarController()
    }
    
    lazy var customTabBar: BaseTabBar = {
        BaseTabBar(frame: self.tabBar.frame)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customTabBar)
        setValue(customTabBar, forKey: "tabBar")
        
        let bookvc = BookListViewController()
        let booknavi = UINavigationController(rootViewController: bookvc)
        bookvc.tabBarItem = UITabBarItem(title: "书库", image: Tabs.book.unSelectedImage, selectedImage: Tabs.book.selectedImage)
        
        let historyvc = HistoryViewController()
        let historynavi = UINavigationController(rootViewController: historyvc)
        historyvc.tabBarItem = UITabBarItem(title: "历史", image: Tabs.book.unSelectedImage, selectedImage: Tabs.book.selectedImage)
        
        viewControllers = [booknavi, historynavi]
        tabBar.isTranslucent = false
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        if let items = tabBar.items {
            for (index, item) in items.enumerated() {
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
                item.tag = index
            }
        }
    }
}
