//
//  PageItem.swift
//  ReaderExample
//
//  Created by sun on 2021/12/30.
//

import UIKit
import SnapKit

class PageItem: UIViewController {
    var chapterIndex: Int = -1
    var subrangeIndex: Int = -1
    var content: String?
    var progress: Float = 0
    var header: String?
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = Appearance.readerTextColor
        return label
    }()
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = Appearance.readerOtherColor
        return label
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = Appearance.readerOtherColor
        return label
    }()
    
    override func loadView() {
        view = TextDisplayView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = Appearance.readerBackgroundColor
        (view as! TextDisplayView).attributesString = NSAttributedString(string: content ?? "", attributes: Appearance.attributes)
        
        titleLabel.text = header
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            let margin = Appearance.displayRect.minX
            let topMargin: CGFloat
            if UIDevice.isNotch {
                topMargin = 40
            } else {
                topMargin = 10
            }
            make.top.equalToSuperview().offset(topMargin)
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
        }
        
        let bottomMargin: CGFloat
        if UIDevice.isNotch {
            bottomMargin = 30
        } else {
            bottomMargin = 10
        }
        
        let powerView = PowerDisplayView()
        powerView.backgroundColor = .clear
        view.addSubview(powerView)
        powerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Appearance.displayRect.minX)
            make.bottom.equalToSuperview().offset(-bottomMargin)
            make.size.equalTo(CGSize(width: 25, height: 12))
        }
        
        
        timeLabel.text = PageItem.dateFormatter.string(from: Date())
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(powerView.snp.right).offset(5)
            make.centerY.equalTo(powerView)
        }
        
        progressLabel.text = String(format: "%.1f%%", progress * 100)
        view.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Appearance.displayRect.minX)
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                (view as! TextDisplayView).attributesString = NSAttributedString(string: content ?? "", attributes: Appearance.attributes)
            }
        }
    }
}

private final class TextDisplayView: UIView {
    var attributesString: NSAttributedString? {
        didSet {
            layer.setNeedsDisplay()
        }
    }
    override class var layerClass: AnyClass {
        AsyncLayer.self
    }
}

extension TextDisplayView: asyncLayerDelegate {
    func newAsyncDisplayTask() -> AsyncLayerDisplayTask {
        let displayTask = AsyncLayerDisplayTask()
        displayTask.display = { (context, size, isCancelled) in
            context.textMatrix = .identity
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1, y: -1)
            
            let frameSetter = CTFramesetterCreateWithAttributedString(self.attributesString ?? NSAttributedString())
            let path = CGPath(rect: Appearance.displayRect, transform: nil)
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
            CTFrameDraw(frame, context)
        }
        return displayTask
    }
}

private final class PowerDisplayView: UIView {
    var batteryLevel: Float {
        UIDevice.current.isBatteryMonitoringEnabled = true
        if UIDevice.current.batteryState == .unknown { return 0 }
        let value = UIDevice.current.batteryLevel
        UIDevice.current.isBatteryMonitoringEnabled = false
        return value
    }
    private lazy var outline: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.contentsScale = UIScreen.main.scale
        if #available(iOS 13, *) {
            shape.strokeColor = Appearance.readerOtherColor.resolvedColor(with: traitCollection).cgColor
        } else {
            shape.strokeColor = Appearance.readerOtherColor.cgColor
        }
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 1
        return shape
    }()
    private lazy var cap: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.contentsScale = UIScreen.main.scale
        shape.strokeColor = UIColor.clear.cgColor
        if #available(iOS 13, *) {
            shape.fillColor = Appearance.readerOtherColor.resolvedColor(with: traitCollection).cgColor
        } else {
            shape.fillColor = Appearance.readerOtherColor.cgColor
        }
        return shape
    }()
    
    private lazy var inner: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.contentsScale = UIScreen.main.scale
        shape.strokeColor = UIColor.clear.cgColor
        if #available(iOS 13, *) {
            shape.fillColor = Appearance.readerOtherColor.resolvedColor(with: traitCollection).cgColor
        } else {
            shape.fillColor = Appearance.readerOtherColor.cgColor
        }
        return shape
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                let color = Appearance.readerOtherColor.resolvedColor(with: traitCollection).cgColor
                outline.strokeColor = color
                cap.fillColor = color
                inner.fillColor = color
            }
        }
    }
    private func setupUI() {
        layer.addSublayer(outline)
        layer.addSublayer(cap)
        layer.addSublayer(inner)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = frame.width
        let height = frame.height
        let padding: CGFloat = 2
        let radius: CGFloat = 2
        let capRadius: CGFloat = height / 6
        
        let outlineWidth = width - capRadius - padding
        let outlineHeight = height - 2
        let outlinePath = UIBezierPath(roundedRect: CGRect(x: 1, y: 1, width: outlineWidth, height: height - 2), cornerRadius: radius)
        outline.path = outlinePath.cgPath
        
        
        let capPath = UIBezierPath(arcCenter: CGPoint(x: outlineWidth + 1 + padding, y: height / 2), radius: capRadius, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: true)
        cap.path = capPath.cgPath

        let innerPath = UIBezierPath(roundedRect: CGRect(x: 1 + padding, y: 1 + padding, width: (outlineWidth - padding * 2) * CGFloat(batteryLevel), height: outlineHeight - padding * 2), cornerRadius: 1)
        inner.path = innerPath.cgPath
    }
}
