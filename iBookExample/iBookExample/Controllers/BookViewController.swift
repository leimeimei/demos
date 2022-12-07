//
//  BookViewController.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import UIKit
import SnapKit
import PDFKit
import Hero

class BookViewController: UIViewController {
    var model: DocumentModel? {
        didSet {
            guard let model = self.model, let url = model.url else { return }
            self.document = PDFDocument(url: url)
        }
    }
    private var document: PDFDocument?
    private var pdfViewGestureRecongizer = PDFViewGestureRecongizer()
    private let barHideOnTagGestureRecognizer = UITapGestureRecognizer()
    private let toggleSegmentedControl = UISegmentedControl(items: [UIImage(named: "Grid")!, UIImage(named: "List")!, UIImage(named: "Bookmark-N")!])
    private var bookmarkButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barHideOnTagGestureRecognizer.addTarget(self, action: #selector(gestureRecognizerToggleVisibility(_:)))
        pdfView.addGestureRecognizer(barHideOnTagGestureRecognizer)
        
        setupUI()
        setupData()
        resume()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pdfViewPageChanged(_:)), name: .PDFViewPageChanged, object: nil)
        
        toggleSegmentedControl.selectedSegmentIndex = 0
        toggleSegmentedControl.addTarget(self, action: #selector(toggleChangeContentView(_:)), for: .valueChanged)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        storageCurrentPage()
        storageHistoryList()
    }
    private func setupUI() {
        let bounds = CGRect(x: 0, y: Device.navBarHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - Device.navBarHeight)
        view.addSubview(thumpnailGridViewContainer)
        thumpnailGridViewContainer.frame = view.bounds
        let gridVC = ThumpnailGridViewController()
        thumpnailGridViewContainer.addSubview(gridVC.view)
        gridVC.view.frame = bounds
        addChild(gridVC)
        gridVC.document = document
        gridVC.delegate = self
        
        view.addSubview(outlineViewContainer)
        outlineViewContainer.frame = view.bounds
        let outlineVC = OutlineViewController()
        outlineViewContainer.addSubview(outlineVC.view)
        outlineVC.view.frame = bounds
        addChild(outlineVC)
        outlineVC.document = document
        outlineVC.delegate = self
        
        view.addSubview(bookmarkViewContainer)
        bookmarkViewContainer.frame = view.bounds
        let markVC = BookmarkViewController()
        bookmarkViewContainer.addSubview(markVC.view)
        markVC.view.frame = bounds
        addChild(markVC)
        markVC.document = document
        markVC.delegate = self
        
        view.addSubview(pdfView)
        pdfView.frame = UIScreen.main.bounds
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Device.navBarHeight + 16)
        }
        
        view.addSubview(pdfThumbnailViewContainer)
        pdfThumbnailViewContainer.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(Device.tabBarHeight)
        }
        pdfThumbnailViewContainer.addSubview(pdfThumbnailView)
        pdfThumbnailView.frame = CGRect(x: 0, y: 0, width: Device.kWidth, height: 44)
        
        view.addSubview(pageNumberLabel)
        pageNumberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pdfThumbnailViewContainer.snp.top).offset(-16)
        }
    }
    private func setupData() {
        pdfView.addGestureRecognizer(pdfViewGestureRecongizer)
        pdfView.document = document
        pdfThumbnailView.layoutMode = .horizontal
        pdfThumbnailView.pdfView = pdfView
        titleLabel.text = document?.documentAttributes?["Title"] as? String
        
        if let docuemntURL = document?.documentURL?.absoluteString {
            let key = docuemntURL.appending("/storageCurrentPage")
            let index = UserDefaults.standard.integer(forKey: key)
            if let page = document?.page(at: index) {
                pdfView.go(to: page)
            }
        }
    }
    
    @objc private func backBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    @objc func gestureRecognizerToggleVisibility(_ gestureRecognzier: UITapGestureRecognizer) {
        if let navigationController = navigationController {
            if navigationController.navigationBar.alpha > 0 {
                hideBars()
            } else {
                showBars()
            }
        }
    }
    @objc func showTableOfContents(_ sender: UIBarButtonItem) {
        showTableOfContents()
    }
    @objc func showActionMemu(_ sender: UIBarButtonItem) {
        let printInteractionController = UIPrintInteractionController.shared
        printInteractionController.printingItem = document?.dataRepresentation()
        printInteractionController.present(animated: true, completionHandler: nil)
    }
    @objc func shwoSearchView(_ sender: UIBarButtonItem) {
        let searchVC = SearchViewController()
        searchVC.document = document
        searchVC.delegate = self
        let naviVC = UINavigationController(rootViewController: searchVC)
        naviVC.modalPresentationStyle = .fullScreen
        Hero.shared.containerColor = .clear
        naviVC.hero.isEnabled = true
        naviVC.hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .fade)
        present(naviVC, animated: true, completion: nil)
    }
    @objc func addOrRemoveBookmark(_ sender: UIBarButtonItem) {
        if let documentURL = document?.documentURL?.absoluteString {
            var bookmarks = UserDefaults.standard.array(forKey: documentURL) as? [Int] ?? [Int]()
            if let currentPage = pdfView.currentPage, let pageIndex = document?.index(for: currentPage) {
                if let index = bookmarks.firstIndex(of: pageIndex) {
                    bookmarks.remove(at: index)
                    UserDefaults.standard.set(bookmarks, forKey: documentURL)
                    bookmarkButton?.image = UIImage(named: "Bookmark-N")
                } else {
                    UserDefaults.standard.set((bookmarks + [pageIndex]).sorted(), forKey: documentURL)
                    bookmarkButton?.image = UIImage(named: "Bookmark-P")
                }
            }
        }
    }
    @objc func pdfViewPageChanged(_ noti: Notification) {
        if pdfViewGestureRecongizer.isTracking {
            hideBars()
        }
        updateBookmarkStatus()
        updatePageNumberLabel()
    }
    @objc func toggleChangeContentView(_ sender: UISegmentedControl) {
        pdfView.isHidden = true
        titleLabel.alpha = 0
        pageNumberLabel.alpha = 0
        
        if toggleSegmentedControl.selectedSegmentIndex == 0 {
            thumpnailGridViewContainer.isHidden = false
            outlineViewContainer.isHidden = true
            bookmarkViewContainer.isHidden = true
        } else if toggleSegmentedControl.selectedSegmentIndex == 1 {
            thumpnailGridViewContainer.isHidden = true
            outlineViewContainer.isHidden = false
            bookmarkViewContainer.isHidden = true
        } else {
            thumpnailGridViewContainer.isHidden = true
            outlineViewContainer.isHidden = true
            bookmarkViewContainer.isHidden = false
        }
    }
    @objc func resume(_ sender: UIBarButtonItem) {
        resume()
    }
    
    private func resume() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backBtnAction))
        let contentsButton = UIBarButtonItem(image: UIImage(named: "List"), style: .plain, target: self, action: #selector(showTableOfContents(_:)))
        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showActionMemu(_:)))
        navigationItem.leftBarButtonItems = [backButton, contentsButton, actionButton]
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(shwoSearchView(_:)))
        let bookmark = UIBarButtonItem(image: UIImage(named: "Bookmark-N"), style: .plain, target: self, action: #selector(addOrRemoveBookmark(_:)))
        bookmarkButton = bookmark
        navigationItem.rightBarButtonItems = [searchButton, bookmark]
        
        pdfView.isHidden = false
        pdfThumbnailViewContainer.alpha = 1
        titleLabel.alpha = 1
        pageNumberLabel.alpha = 1
        thumpnailGridViewContainer.isHidden = true
        outlineViewContainer.isHidden = true
        bookmarkViewContainer.isHidden = true
        
        barHideOnTagGestureRecognizer.isEnabled = true
        updateBookmarkStatus()
        updatePageNumberLabel()
    }
    private func showTableOfContents() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backBtnAction))
        let toggleButton = UIBarButtonItem(customView: toggleSegmentedControl)
        let resumebarButton = UIBarButtonItem(title: NSLocalizedString("续读", comment: ""), style: .plain, target: self, action: #selector(resume(_:)))
        navigationItem.leftBarButtonItems = [backButton, toggleButton]
        navigationItem.rightBarButtonItems = [resumebarButton]
        
        pdfThumbnailViewContainer.alpha = 0
        toggleChangeContentView(toggleSegmentedControl)
        barHideOnTagGestureRecognizer.isEnabled = false
    }
    private func updateBookmarkStatus() {
        if let documentURL = self.document?.documentURL?.absoluteString,
            let bookmarks = UserDefaults.standard.array(forKey: documentURL) as? [Int],
            let currentPage = pdfView.currentPage,
            let index = self.document?.index(for: currentPage) {
            self.bookmarkButton?.image = bookmarks.contains(index) ? UIImage(named: "Bookmark-P") : UIImage(named: "Bookmark-N")
        }
    }
    private func updatePageNumberLabel() {
        if let currentPage = pdfView.currentPage, let index = document?.index(for: currentPage), let pageCount = document?.pageCount {
            pageNumberLabel.text = String(format: "%d/%d", index + 1, pageCount)
        } else {
            pageNumberLabel.text = nil
        }
    }
    private func showBars() {
        if let navigationController = navigationController {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                navigationController.navigationBar.alpha = 1
                self.pdfThumbnailViewContainer.alpha = 1
                self.titleLabel.alpha = 1
                self.pageNumberLabel.alpha = 1
            }
        }
    }
    private func hideBars() {
        if let navigationController = navigationController {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                navigationController.navigationBar.alpha = 0
                self.pdfThumbnailViewContainer.alpha = 0
                self.titleLabel.alpha = 0
                self.pageNumberLabel.alpha = 0
            }
        }
    }
    private func storageHistoryList() {
        if let documentURL = self.document?.documentURL?.absoluteString {
            
            let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].absoluteString
            let key = cache.appending("com.sxl.ibook.storageHistory")
            if var documentURLs = UserDefaults.standard.array(forKey: key) as? [String] {
                
                if !documentURLs.contains(documentURL) {
                    // 不存在则存储
                    documentURLs.append(documentURL)
                    UserDefaults.standard.set(documentURLs, forKey: key)
                }
            } else {
                // 第一次存储
                UserDefaults.standard.set([documentURL], forKey: key)
            }
        }
    }
    private func storageCurrentPage() {
        if let documentURL = self.document?.documentURL?.absoluteString {
            
            let key = documentURL.appending("/storgeCurrentPage")
            if let currentPage = self.pdfView.currentPage, let index = self.document?.index(for: currentPage) {
                UserDefaults.standard.set(index, forKey: key)
            }
        }
    }
    
    fileprivate lazy var thumpnailGridViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var outlineViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var bookmarkViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var pdfView: PDFView = {
        
        let view = PDFView()
        view.backgroundColor = Device.bgColor
        view.autoScales = true
        view.displayMode = .singlePage
        view.displayDirection = .horizontal
        view.usePageViewController(true, withViewOptions: [UIPageViewController.OptionsKey.spineLocation: 20])
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()
    private lazy var pageNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()
    private lazy var pdfThumbnailViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var pdfThumbnailView: PDFThumbnailView = {
        let view = PDFThumbnailView()
        view.backgroundColor = .white
        return view
    }()
}

class PDFViewGestureRecongizer: UIGestureRecognizer {
    var isTracking = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        isTracking = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        isTracking = false
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        isTracking = false
    }
}

extension BookViewController: ThumpnailGridViewControllerDelegate {
    func thumbnailGridViewController(_ thumbnailGridViewController: ThumpnailGridViewController, didSelectPage page: PDFPage) {
        resume()
        pdfView.go(to: page)
    }
}

extension BookViewController: OutlineViewControllerDelegate {
    func outlineViewController(_ outlineViewController: OutlineViewController, didSelectOutlineAt destination: PDFDestination) {
        resume()
        pdfView.go(to: destination)
    }
}

extension BookViewController: BookmarkViewControllerDelegate {
    func bookmarkViewController(_ bookmarkViewController: BookmarkViewController, didSelectPage page: PDFPage) {
        resume()
        pdfView.go(to: page)
    }
}

extension BookViewController: SearchViewControllerDelegate {
    func searchViewController(_ searchViewController: SearchViewController, didSelectSearchResult selection: PDFSelection) {
        pdfView.currentSelection = selection
        pdfView.go(to: selection)
        showBars()
    }
}
