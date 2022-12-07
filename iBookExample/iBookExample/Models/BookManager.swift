//
//  BookManager.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import Foundation
import PDFKit

class BookManager {
    static let shared = BookManager()
    
    func getDocument(_ pdfDoc: PDFDocument?) -> DocumentModel {
        var model = DocumentModel()
        if let document = pdfDoc, let documentAttributes = document.documentAttributes {
            if let title = documentAttributes["Title"] as? String {
                model.title = title
            } else {
                model.title = "No Title"
            }
            if let author = documentAttributes["Author"] as? String {
                model.author = author
            } else {
                model.author = "No Author"
            }
            if document.pageCount > 0, let page = document.page(at: 0) {
                let imgWidth: CGFloat = (UIScreen.main.bounds.width - 48) / 2 - 24
                let imgHeight:CGFloat = 190
                let thumpnail = page.thumbnail(of: CGSize(width: imgWidth, height: imgHeight), for: .cropBox)
                model.coverImage = thumpnail
            }
            if let url = document.documentURL {
                model.url = url
            }
        }
        return model
    }
}
