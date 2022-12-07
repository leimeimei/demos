//
//  BookListViewController.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import UIKit
import PDFKit

class BookListViewController: UIViewController {
    var models: [DocumentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "书库"
        view.backgroundColor = .white
        view.addSubview(collection)
        collection.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 88)
        
        refreshData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cacheDirectoryDidChange(_:)), name: .cacheDirectoryDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cacheDirectoryDidOpenPDF(_:)), name: .cacheDirectoryDidOpen, object: nil)
    }
    
    private func refreshData() {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        if let contents = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
            let urls = contents.filter{ $0.absoluteString.contains(".pdf")}
            self.models = urls.compactMap{ BookManager.shared.getDocument(PDFDocument(url: $0))}
            collection.reloadData()
        }
    }
    
    @objc func cacheDirectoryDidChange(_ nofi: Notification) {
        refreshData()
    }
    
    @objc func cacheDirectoryDidOpenPDF(_ noti: Notification) {
        refreshData()
        if let url = noti.object as? URL {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                let bookVc = BookViewController()
                bookVc.model = BookManager.shared.getDocument(PDFDocument(url: url))
                let navi = UINavigationController(rootViewController: bookVc)
                navi.modalPresentationStyle = .fullScreen
                navi.hero.isEnabled = true
                navi.hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .push(direction: .right))
                self.present(navi, animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 48)/2, height: 240)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        return layout
    }()
    
    fileprivate lazy var collection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collection.backgroundColor = Device.bgColor
        collection.register(cellType: BooksCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
}

extension BookListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        GeneratorManager.shared.impactFeedBack(.light)
        if let cell = collection.cellForItem(at: indexPath) as? BooksCell {
            let bookVc = BookViewController()
            bookVc.model = models[indexPath.item]
            cell.hero.id = "BooksCell\(indexPath.item)"
            bookVc.pdfView.hero.id = "BooksCell\(indexPath.item)"
            let navi = UINavigationController(rootViewController: bookVc)
            navi.modalPresentationStyle = .fullScreen
            navi.hero.isEnabled = true
            self.present(navi, animated: true, completion: nil)
        }
    }
}
extension BookListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(for: indexPath, cellType: BooksCell.self)
        let model = models[indexPath.item]
        cell.title = model.title
        cell.image = model.coverImage
        return cell
    }
    
    
}
