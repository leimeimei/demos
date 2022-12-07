//
//  PageViewControllerDataSource.swift
//  ReaderExample
//
//  Created by sun on 2021/12/30.
//

import UIKit

class PageViewControllerDataSource: NSObject {
    var name: String?
    var sourcePath: URL?
    private var text: NSString?
    private(set) var chapters: [ChapterModel]?
    private var isReversePage = true
    
    func parseChapter() {
        guard let sourcePath = sourcePath else {
            return
        }
        text = try? NSString(contentsOf: sourcePath, encoding: String.Encoding.utf8.rawValue)
        if text == nil {
            text = try? NSString(contentsOf: sourcePath, encoding: 0x80000632)
        }
        guard let text = text else {
            return
        }
        let pattern = #"(?<=\s)[第]{0,1}[0-9零一二三四五六七八九十百千万]+[章节卷集](?: |　|：){0,4}(?:\S)*"#
        let expression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matchResults = expression.matches(in: text as String, options: .reportCompletion, range: NSRange(location: 0, length: text.length))
        var chapertArr = [ChapterModel]()
        if !matchResults.isEmpty && (text.length / matchResults.count) < 30000 {
            var lastRange = NSRange()
            for (idx, value) in matchResults.enumerated() {
                let range = value.range
                if idx == 0 {
                    if range.location - lastRange.upperBound > 100 {
                        let aRange = NSRange(location: 0, length: range.location)
                        let chapter = ChapterModel(title: "序言", content: text.substring(with: aRange), range: aRange)
                        chapertArr.append(chapter)
                        lastRange = range
                    } else {
                        lastRange.length = range.upperBound - lastRange.location
                    }
                } else {
                    if range.location - lastRange.upperBound < 50 {
                        lastRange.length = range.upperBound - lastRange.location
                    } else {
                        let aRange = NSRange(location: lastRange.location, length: range.location - lastRange.location)
                        let chapter = ChapterModel(title: text.substring(with: lastRange), content: text.substring(with: aRange), range: aRange)
                        chapertArr.append(chapter)
                        lastRange = range
                    }
                }
            }
            let aRange = NSRange(location: lastRange.location, length: text.length - lastRange.location)
            let chapter = ChapterModel(title: text.substring(with: lastRange), content: text.substring(with: aRange), range: aRange)
            chapertArr.append(chapter)
        } else {
            let totalCount = text.length
            var currentLocal = 0

            while currentLocal < totalCount {
                let length = min(totalCount - currentLocal, 10000)
                let range = NSRange(location: currentLocal, length: length)
                debugPrint(range)
                let chapter = ChapterModel(content: text.substring(with: range), range: range)
                chapertArr.append(chapter)
                currentLocal += range.length
            }
        }
        chapters = chapertArr
    }
    
    func updateChapterSubRange() {
        chapters?.forEach{ $0.updateSubranges() }
    }
}

extension PageViewControllerDataSource {
    func pageItem(atChapter chapterIndex: Int, subrangeIndex: Int) -> PageItem? {
        guard let chapters = chapters else { return nil }
        if chapterIndex >= chapters.count {
            return nil
        }
        let chapter = chapters[chapterIndex]
        if subrangeIndex >= chapter.subranges.count {
            return nil
        }
        let pageItem = PageItem()
        pageItem.header = name
        pageItem.chapterIndex = chapterIndex
        pageItem.subrangeIndex = subrangeIndex
        pageItem.content = (chapter.content as NSString).substring(with: chapter.subranges[subrangeIndex])
        pageItem.progress = progress(atChapter: chapterIndex, subrangeIndex: subrangeIndex)!
        return pageItem
    }
    
    private func reversePageItem(atChapter chapterIndex: Int, subrangeIndex: Int) -> ReversePageItem {
        let reverseItem = ReversePageItem()
        reverseItem.chapterIndex = chapterIndex
        reverseItem.subrangeIndex = subrangeIndex
        return reverseItem
    }
    
    func chapterSubrangeIndex(atChapter chapterIndex: Int, sublocation: Int) -> Int? {
        guard let chapters = chapters else { return nil }
        if chapterIndex >= chapters.count { return nil }
        let chapter = chapters[chapterIndex]
        if sublocation >= chapter.range.length { return nil }
        var start = 0
        var end = chapter.subranges.count - 1
        while start <= end {
            let mid = start + (end - start) / 2
            let subrange = chapter.subranges[mid]
            if sublocation < subrange.location {
                end = mid - 1
            } else if sublocation >= subrange.upperBound {
                start = mid + 1
            } else {
                return mid
            }
        }
        return nil
    }
    
    func pageItem(at location: Int) -> PageItem? {
        guard let (chapterIndex, subrangeIndex) = searchPageLocation(location: location) else { return nil }
        let chapter = chapters![chapterIndex]
        let pageItem = PageItem()
        pageItem.chapterIndex = chapterIndex
        pageItem.subrangeIndex = subrangeIndex
        pageItem.content = (chapter.content as NSString).substring(with: chapter.subranges[subrangeIndex])
        return pageItem
    }
    
    func locaiton(atChpater chapterIndex: Int, subrangeIndex: Int) -> Int? {
        guard let chapters = chapters else { return nil }
        if chapterIndex >= chapters.count {
            return nil
        }
        let chapter = chapters[chapterIndex]
        if subrangeIndex >= chapter.subranges.count { return nil }
        let subrange = chapter.subranges[subrangeIndex]
        return chapter.range.location + subrange.location
    }
    
    func progress(atChapter chapterIndex: Int, subrangeIndex: Int) -> Float? {
        guard let chapters = chapters else { return nil }
        if chapterIndex == chapters.count - 1 && subrangeIndex == chapters[chapterIndex].subranges.count - 1 {
            return 1
        }
        if let location = locaiton(atChpater: chapterIndex, subrangeIndex: subrangeIndex) {
            return Float(location) / Float(text!.length)
        }
        return 0
    }
    
    func chapterSublocation(atChapter chapterIndex: Int, subrangeIndex: Int) -> Int? {
        guard let chapters = chapters else { return nil }
        
        if chapterIndex >= chapters.count {
            return nil
        }
        let chapter = chapters[chapterIndex]
        if subrangeIndex >= chapter.subranges.count {
            return nil
        }
        return chapter.subranges[subrangeIndex].location
    }
    
    func searchPageLocation(location: Int) -> (chapterIndex: Int, subrangeIndex: Int)? {
        guard let chapters = chapters else { return nil }

        var low = 0
        var up = chapters.count - 1
        var chapterIndex = -1
        
        while low <= up {
            let mid = low + (up - low) / 2
            let chapter = chapters[mid]
            if location < chapter.range.location {
                up = mid - 1
            } else if location >= chapter.range.upperBound {
                low = mid + 1
            } else {
                chapterIndex = mid
                break
            }
        }
        
        if chapterIndex == -1 { return nil }
        
        let chapter = chapters[chapterIndex]
        
        let newLocation = location - chapter.range.location
        var start = 0
        var end = chapter.subranges.count - 1
        
        while start <= end {
            let mid = start + (end - start) / 2
            let subrange = chapter.subranges[mid]
            if newLocation < subrange.location {
                end = mid - 1
            } else if newLocation >= subrange.upperBound {
                start = mid + 1
            } else {
                return (chapterIndex, mid)
            }
        }
        return nil
    }
}

extension PageViewControllerDataSource: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let chapters = chapters else { return nil }
        if let pageItem = viewController as? PageItem {
            if pageItem.subrangeIndex == 0 {
                if pageItem.chapterIndex == 0 {
                    return nil
                } else {
                    let chapter = chapters[pageItem.chapterIndex - 1]
                    return reversePageItem(atChapter: pageItem.chapterIndex - 1, subrangeIndex: chapter.subranges.count - 1)
                }
            }
            return reversePageItem(atChapter: pageItem.chapterIndex, subrangeIndex: pageItem.subrangeIndex - 1)
        } else if let reverseItem = viewController as? ReversePageItem {
            return pageItem(atChapter: reverseItem.chapterIndex, subrangeIndex: reverseItem.subrangeIndex)
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let chapters = chapters else { return nil }
        
        if let reverseItem = viewController as? ReversePageItem {
            let chapter = chapters[reverseItem.chapterIndex]
            if reverseItem.subrangeIndex >= chapter.subranges.count - 1 {
                if reverseItem.chapterIndex >= chapters.count - 1 {
                    return nil
                } else {
                    return pageItem(atChapter: reverseItem.chapterIndex + 1, subrangeIndex: 0)
                }
            }
            return pageItem(atChapter: reverseItem.chapterIndex, subrangeIndex: reverseItem.subrangeIndex + 1)
        } else if let pageItem = viewController as? PageItem {
            return reversePageItem(atChapter: pageItem.chapterIndex, subrangeIndex: pageItem.subrangeIndex)
        } else {
            return nil
        }
    }
}
