//
//  UploaderViewController.swift
//  ReaderExample
//
//  Created by sun on 2021/12/31.
//

import UIKit
import GCDWebServer

class UploaderViewController: BaseViewController {
    private var webUploader: ReaderWebUploader?
    private lazy var hostLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startUploadServer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let attributeStr = NSMutableAttributedString(string: "请确保手机和电脑在同一wifi下，在电脑浏览器上打开如下地址:\n", attributes: [.font: UIFont.systemFont(ofSize: 17)])
        let ipStr = NSAttributedString(string: "\(webUploader?.serverURL?.absoluteString ?? "无效地址")", attributes: [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.systemBlue])
        attributeStr.append(ipStr)
        hostLabel.attributedText = attributeStr
    }
    private func setupUI() {
        title = "书本上传"
        view.addSubview(hostLabel)
        hostLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    private func startUploadServer() {
        webUploader = ReaderWebUploader(uploadDirectory: Constants.localBookDirectory)
        webUploader?.allowedFileExtensions = ["txt"]
        webUploader?.prologue = "请将书本拖至下方方框，或者点击上传按钮，目前只支持txt格式"
        webUploader?.delegate = self
        webUploader?.start(withPort: 8866, bonjourName: "Reader Uploader Server")
    }
    deinit {
        webUploader?.stop()
    }
}
extension UploaderViewController: GCDWebUploaderDelegate {
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        
    }
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        
    }
}

class ReaderWebUploader: GCDWebUploader {
    override func shouldMoveItem(fromPath: String, toPath: String) -> Bool {
        false
    }
    override func shouldCreateDirectory(atPath path: String) -> Bool {
        false
    }
}
