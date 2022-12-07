//
//  BookmarkViewController.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import UIKit
import PDFKit
import DZNEmptyDataSet

protocol BookmarkViewControllerDelegate: AnyObject {
    func bookmarkViewController(_ bookmarkViewController: BookmarkViewController, didSelectPage page: PDFPage)
}

class BookmarkViewController: UIViewController {
    var document: PDFDocument? {
        didSet {
            if let _ = document {
                refreshData()
            }
        }
    }
    weak var delegate: BookmarkViewControllerDelegate?
    private let thumbnailCache = NSCache<NSNumber, UIImage>()
    private let downlaodQueue = DispatchQueue(label: "com.sxl.pdfview.thumbnail")
    fileprivate var bookmarks: [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(collection)
        collection.frame = view.bounds
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange(_:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func refreshData() {
        
        if let documentURL = document?.documentURL?.absoluteString, let bookmarks = UserDefaults.standard.array(forKey: documentURL) as? [Int] {
            self.bookmarks = bookmarks
            collection.reloadData()
        }
    }
    
    @objc
    func userDefaultsDidChange(_ notification: Notification) {
        refreshData()
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.itemSize = CGSize(width: (UIScreen.main.bounds.width - 16 * 4)/3, height: 140)
        lay.minimumInteritemSpacing = 16
        lay.minimumLineSpacing = 16
        return lay
    }()
    
    fileprivate lazy var collection: UICollectionView = {
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collection.backgroundColor = Device.bgColor
        collection.register(cellType: GridCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.emptyDataSetSource = self
        collection.emptyDataSetDelegate = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
}

extension BookmarkViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GridCell.self)
        
        let pageNumber = bookmarks[indexPath.item]
        if let page = document?.page(at: pageNumber) {
            cell.pageNumber = pageNumber
            let key = NSNumber(value: pageNumber)
            if let thumbnail = thumbnailCache.object(forKey: key) {
                cell.image = thumbnail
            } else {
                let cellSize = CGSize(width: (UIScreen.main.bounds.width - 16 * 4)/3, height: 140)
                downlaodQueue.async {
                    let thumbnail = page.thumbnail(of: cellSize, for: .cropBox)
                    self.thumbnailCache.setObject(thumbnail, forKey: key)
                    if cell.pageNumber == pageNumber {
                        DispatchQueue.main.async {
                            cell.image = thumbnail
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        GeneratorManager.shared.impactFeedBack(.light)
        if let page = document?.page(at: bookmarks[indexPath.item]) {
            delegate?.bookmarkViewController(self, didSelectPage: page)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension BookmarkViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {

        -44
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        NSAttributedString(string: "暂无收藏", font: UIFont.boldSystemFont(ofSize: 18), color: UIColor.gray)
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        true
    }
}

