//
//  FileManagerExtensions.swift
//  Picture
//
//  Created by sun on 2022/10/31.
//

import Foundation

extension FileManager {
    
    var documentDirectory: URL? {
        self.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func copyItemToDocumentDirectory(from sourceURL: URL) -> URL? {
        guard let documentDirectory = documentDirectory else { return nil }
        let fileName = sourceURL.lastPathComponent
        let destinationURL = documentDirectory.appendingPathExtension(fileName)
        if self.fileExists(atPath: destinationURL.path) {
            return destinationURL
        } else {
            do {
                try self.copyItem(at: sourceURL, to: destinationURL)
                return destinationURL
            } catch let error {
                print("unable to copy file:\(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func removeItemFromDocumentDirectory(url: URL) {
        guard let documentDirectory = documentDirectory else { return }
        let fileName = url.lastPathComponent
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        if self.fileExists(atPath: fileUrl.path) {
            do {
                try self.removeItem(at: url)
            } catch let error {
                print("unable to remove file:\(error.localizedDescription)")
            }
        }
    }
    
    func getContentOfDirectory(_ url: URL) -> [URL] {
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            return []
        }
        do {
            return try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch let error {
            print("unable to get directory contents:\(error.localizedDescription)")
        }
        return []
    }
}
