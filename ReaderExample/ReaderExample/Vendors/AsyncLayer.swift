//
//  AsyncLayer.swift
//  ReaderExample
//
//  Created by sun on 2021/12/27.
//

import UIKit

class AsyncLayerDisplayTask {
    var willDisplay: ((_ layer: CALayer) -> Void)?
    var display:((_ context: CGContext, _ size: CGSize, _ cancelled: @escaping () -> Bool) -> Void)?
    var didDisplay: ((_ layer: CALayer, _ finished: Bool) -> Void)?
}
private func asyncLayerGetDisplayQueue() -> DispatchQueue {
    DispatchQueue.global(qos: .userInitiated)
}
protocol asyncLayerDelegate: CALayerDelegate {
    func newAsyncDisplayTask() -> AsyncLayerDisplayTask
}
final class AsyncLayer: CALayer {
    var isDisplayedAsynchronously: Bool = true
    private var _sentinel: Sentinel = Sentinel()
    override init() {
        super.init()
        contentsScale = UIScreen.main.scale
    }
    override init(layer: Any) {
        super.init(layer: layer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        _sentinel.increase()
    }
    override class func defaultValue(forKey key: String) -> Any? {
        if key == "dispalysAsynchronously" {
            return true
        } else {
            return super.defaultValue(forKey:key)
        }
    }
    override func setNeedsLayout() {
        _cancelAsyncDisplay()
        super.setNeedsLayout()
    }
    override func display() {
        super.contents = super.contents
        displayAsync(isDisplayedAsynchronously)
    }
    private func displayAsync(_ async: Bool) {
        guard let asyncDelegate = delegate as? asyncLayerDelegate else { return }
        let task = asyncDelegate.newAsyncDisplayTask()
        if task.display == nil {
            task.willDisplay?(self)
            contents = nil
            task.didDisplay?(self, true)
            return
        }
        task.willDisplay?(self)
        let size = bounds.size
        if size.width < 1 || size.height < 1 {
            contents = nil
            task.didDisplay?(self, true)
            return
        }
        if async {
            let value = _sentinel.value()
            let isCancelled: () -> Bool = {
                value != self._sentinel.value()
            }
            asyncLayerGetDisplayQueue().async {
                if isCancelled() { return }
                
                let format: UIGraphicsImageRendererFormat
                if #available(iOS 11, *) {
                    format = UIGraphicsImageRendererFormat.preferred()
                } else {
                    format = UIGraphicsImageRendererFormat.default()
                }
                let renderer = UIGraphicsImageRenderer(size: size, format: format)
                let image = renderer.image { (rendererCtx) in
                    let context = rendererCtx.cgContext
                    task.display?(context, size, isCancelled)
                }
                if isCancelled() {
                    DispatchQueue.main.async {
                        task.didDisplay?(self, false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    if isCancelled() {
                        task.didDisplay?(self, false)
                    } else {
                        self.contents = image.cgImage
                        task.didDisplay?(self, true)
                    }
                }
            }
        } else {
            _sentinel.increase()
            let format: UIGraphicsImageRendererFormat
            if #available(iOS 11, *) {
                format = UIGraphicsImageRendererFormat.preferred()
            } else {
                format = UIGraphicsImageRendererFormat.default()
            }
            let renderer = UIGraphicsImageRenderer(size: size, format: format)
            let image = renderer.image { (rendererCtx) in
                let context = rendererCtx.cgContext
                task.display?(context, size, { return false })
            }
            contents = image.cgImage
            task.didDisplay?(self, true)
        }
    }
    
    private func _cancelAsyncDisplay() {
        _sentinel.increase()
    }
    private func _clear() {
        contents = nil
        _cancelAsyncDisplay()
    }
}
