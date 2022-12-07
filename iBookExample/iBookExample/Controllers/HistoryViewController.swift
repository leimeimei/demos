//
//  HistoryViewController.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import UIKit
import PDFKit
import DZNEmptyDataSet

class HistoryViewController: UIViewController {
    var models: [DocumentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "阅读历史"
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 88)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    fileprivate func refreshData() {
        let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].absoluteString
        let key = cache.appending("com.sxl.ibook.storageHistory")
        if let documentUrls = UserDefaults.standard.array(forKey: key) as? [String] {
            var urls: [URL] = []
            for str in documentUrls {
                if str.contains(".pdf"), let url = URL(string: str) {
                    urls.append(url)
                }
            }
            models = urls.compactMap{ BookManager.shared.getDocument(PDFDocument(url: $0))}
            tableView.reloadData()
        }
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120 + 16
        tableView.isScrollEnabled = true
        tableView.backgroundColor = Device.bgColor
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.register(cellType: HistoryCell.self)
        return tableView
    }()
}
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HistoryCell.self)
        let model = models[indexPath.row]
        cell.title = model.title
        cell.author = model.author
        cell.image = model.coverImage
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        GeneratorManager.shared.impactFeedBack(.light)
        if let cell = tableView.cellForRow(at: indexPath) as? HistoryCell {

            let bookVC = BookViewController()
            bookVC.model = self.models[indexPath.item]
            cell.hero.id = "HistoryCell\(indexPath.item)"
            bookVC.pdfView.hero.id = "HistoryCell\(indexPath.item)"
            let nav = UINavigationController(rootViewController: bookVC)
            nav.modalPresentationStyle = .fullScreen
            nav.hero.isEnabled = true
            self.present(nav, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.models.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if let url = self.models[indexPath.item].url {
                deletePDFDocument(url.absoluteString)
            }
        }
    }
    
    func deletePDFDocument(_ str: String) {
        
        let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].absoluteString
        let key = cache.appending("com.sxl.ibook.storageHistory")
        if var documentURLs = UserDefaults.standard.array(forKey: key) as? [String] {
            
            if documentURLs.contains(str) {
                for (i, docment) in documentURLs.enumerated() {
                    if str == docment {
                        documentURLs.remove(at: i)
                        break
                    }
                }
                UserDefaults.standard.set(documentURLs, forKey: key)
            }
        }
        refreshData()
    }
}

extension HistoryViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        44
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        NSAttributedString(string: "暂无阅读历史", font: UIFont.boldSystemFont(ofSize: 18),color: .gray)
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        true
    }
}
