//
//  Constants.swift
//  ReaderExample
//
//  Created by sun on 2021/12/27.
//

import Foundation

struct Constants {
    static let localBookDirectory: String = {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        path = (path as NSString).appendingPathComponent("localBooks")
        if FileManager.default.fileExists(atPath: path) == false {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }()
    
    static let databaseDirectory: String = {
        var path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent("ReaderDatabase")
        if FileManager.default.fileExists(atPath: path) == false {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }()
}
