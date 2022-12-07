//
//  ReaderViewController.swift
//  ReaderExample
//
//  Created by sun on 2021/12/30.
//

import UIKit

protocol BookResourceProtocol {
    var name: String { get }
    var localPath: URL { get }
}

class ReaderViewController: BaseViewController {
    var book: BookResourceProtocol?
    private lazy var dataSource = PageViewControllerDataSource()
    private lazy var bottomBar = ReaderBottomBar()
    private var hideStatusBar = true
    
    private lazy var pageViewController: UIPageViewController = {
        let page = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        page.dataSource = dataSource
        page.isDoubleSided = true
        page.gestureRecognizers[1].isEnabled = false
        return page
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        dataSource.parseChapter()
        
        if let book = book {
            let pageLocation = Database.shared.pageLocation(forBook: book.name)
            showPageItem(atChapter: pageLocation.chapterIndex, subrangeIndex: pageLocation.subrangeIndex)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        savePageLocation()
    }
    
    private func setupUI() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomBar.isHidden = true
        bottomBar.delegate = self
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            let height: CGFloat = UIDevice.isNotch ? 120 : 100
            make.height.equalTo(height)
        }
        
        navigationBarConfigure.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(savePageLocation), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    private func setupDataSource() {
        dataSource.name = book?.name
        dataSource.sourcePath = book?.localPath
    }
    
    @objc func showOrHidden() {
        let hidden = navigationBarConfigure.isHidden ?? false
        let duration = TimeInterval(UINavigationController.hideShowBarDuration)
        if hidden {
            bottomBar.isHidden = false
            if let currentPage = pageViewController.viewControllers?.first as? PageItem {
                bottomBar.progress = dataSource.progress(atChapter: currentPage.chapterIndex, subrangeIndex: currentPage.subrangeIndex)!
            }
            UIView.animate(withDuration: duration) {
                self.bottomBar.snp.updateConstraints { make in
                    make.bottom.equalToSuperview()
                }
                self.bottomBar.superview?.layoutIfNeeded()
            }
        } else {
            let bottomBarH = bottomBar.frame.height
            UIView.animate(withDuration: duration) {
                self.bottomBar.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(bottomBarH)
                }
                self.bottomBar.superview?.layoutIfNeeded()
            } completion: { _ in
                self.bottomBar.isHidden = true
            }
        }
        
        pageViewController.gestureRecognizers[0].isEnabled = !hidden
        hideStatusBar = !hidden
        setNeedsStatusBarAppearanceUpdate()
        navigationBarConfigure.isHidden = !hidden
        flushBarConfigure(true)
    }
    
    private func showPageItem(atChapter chapterIndex: Int, subrangeIndex: Int, animated: Bool = false) {
        guard let item = dataSource.pageItem(atChapter: chapterIndex, subrangeIndex: subrangeIndex) else { return }
        pageViewController.setViewControllers([item], direction: .forward, animated: animated, completion: nil)
    }
    private func showNextPage() {
        guard let currentPage = pageViewController.viewControllers?.first as? PageItem,
              let currentReverse = dataSource.pageViewController(pageViewController, viewControllerAfter: currentPage),
              let next = dataSource.pageViewController(pageViewController, viewControllerAfter: currentReverse) else { return }
        pageViewController.setViewControllers([next, currentReverse], direction: .forward, animated: true, completion: nil)
                
    }
    
    @objc func savePageLocation() {
        guard let currentPage = pageViewController.viewControllers?.first as? PageItem,
              let book = book else { return }
        
        let pageLocal = PageLocation(chapterIndex: currentPage.chapterIndex, subrangeIndex: currentPage.subrangeIndex, progress: Double(currentPage.progress))
        Database.shared.save(pageLocal, forBook: book.name)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let hidden = navigationController?.navigationBar.isHidden ?? false
        if !hidden {
            showOrHidden()
            return
        }
        let centerX = view.frame.width / 2
        let centerXEnable = view.frame.width / 6
        let centerY = view.frame.height / 2
        let centerYEnable = view.frame.height / 6
        let local = touches.first!.location(in: view)
        
        if local.x < centerX - centerXEnable || local.x > centerX + centerXEnable ||
            local.y > centerY + centerYEnable || local.y < centerY - centerYEnable { // 左右两边点击 跳转下一页
            showNextPage()
        } else {
            showOrHidden()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        hideStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        .slide
    }
}

extension ReaderViewController: ReaderBottomBarDelegate {
    func readerBottomBar(_ bottomBar: ReaderBottomBar, didChangeFontSizeTo result: ReaderBottomBar.FontChangeResult) {
        var currentSize = Appearance.fontSize
        switch result {
        case .smaller:
            if currentSize < 10 { return }
            currentSize -= 1
        case .bigger:
            if currentSize > 28 { return }
            currentSize += 1
        }
        Appearance.fontSize = currentSize
        guard let currentPage = pageViewController.viewControllers?.first as? PageItem,
              let sublocaiton = dataSource.chapterSublocation(atChapter: currentPage.chapterIndex, subrangeIndex: currentPage.subrangeIndex)
        else { return }
        
        dataSource.updateChapterSubRange()
        guard let subrangeIndex = dataSource.chapterSubrangeIndex(atChapter: currentPage.chapterIndex, sublocation: sublocaiton) else { return }
        
        showPageItem(atChapter: currentPage.chapterIndex, subrangeIndex: subrangeIndex)
    }
    
    func readerBottomBar(_ bottomBar: ReaderBottomBar, didChangeProgressTo value: Float) {
        if let chapter = dataSource.chapters?.last {
            let totalLength = chapter.range.upperBound - 1
            let location = value * Float(totalLength)
            if let (chapterIndex, subrangeIndex) = dataSource.searchPageLocation(location: Int(location)) {
                showPageItem(atChapter: chapterIndex, subrangeIndex: subrangeIndex)
            }
        }
    }
}
