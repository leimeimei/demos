//
//  ThumpnailGridViewController.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import UIKit
import PDFKit

protocol ThumpnailGridViewControllerDelegate: AnyObject {
    func thumbnailGridViewController(_ thumbnailGridViewController: ThumpnailGridViewController, didSelectPage page: PDFPage)
}

class ThumpnailGridViewController: UIViewController {
    var document: PDFDocument? {
        didSet {
            if let _ = document {
                collection.reloadData()
            }
        }
    }
    weak var delegate: ThumpnailGridViewControllerDelegate?
    
    fileprivate let thumbnailCache = NSCache<NSNumber, UIImage>()
    private let downloadQueue = DispatchQueue(label: "com.sxl.pdfview.thumbnail")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collection)
        collection.frame = view.bounds
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 16 * 4) / 3,  height: 140)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        return layout
    }()
    
    fileprivate lazy var collection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collection.backgroundColor = Device.bgColor
        collection.register(cellType: GridCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
}

extension ThumpnailGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let doc = document {
            return doc.pageCount
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GridCell.self)
        if let doc = document, let page = doc.page(at: indexPath.item) {
            let pageNumber = indexPath.item
            cell.pageNumber = pageNumber
            let key = NSNumber(value: pageNumber)
            if let thumbnail = thumbnailCache.object(forKey: key) {
                cell.image = thumbnail
            } else {
                let cellSize = CGSize(width: (UIScreen.main.bounds.width - 16 * 4)/3, height: 140)
                downloadQueue.async {
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
        if let page = document?.page(at: indexPath.item) {
            delegate?.thumbnailGridViewController(self, didSelectPage: page)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
