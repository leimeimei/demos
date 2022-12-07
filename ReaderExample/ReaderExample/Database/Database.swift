//
//  Database.swift
//  ReaderExample
//
//  Created by sun on 2021/12/27.
//

import Foundation

final class Database {
    static let shared = Database()
    
    let safeQueue: SQLiteQueue = {
        let path = (Constants.databaseDirectory as NSString).appendingPathComponent("reader.db")
        let queue = try! SQLiteQueue(path)
        queue.inDatabase { db in
            do {
                try db.execute(sql: "CREATE TABLE IF NOT EXISTS book_list (name TEXT PRIMARY KEY, last_access REAL DEFAULT 0, chapter_index INTEGER DEFAULT 0, subrange_index INTEGER DEFAULT 0, progress REAL DEFAULT 0);")
            } catch {
                debugPrint("failed")
            }
        }
        return queue
    }()
    
    // 获取书籍列表
    func loadBookList() -> [BookModel] {
        var books = [BookModel]()
        safeQueue.inDatabase { db in
            try? db.executeQuery(statement: "SELECT name, last_access, progress FROM book_list;", doBindings: { _ in
                
            }, handleRow: { stmt, _ in
                let name = stmt.columnName(position: 0)
                let lastAccess = stmt.columnDouble(position: 1)
                let progress = stmt.columnDouble(position: 2)
                var localPath = (Constants.localBookDirectory as NSString).appendingPathComponent(name)
                localPath = (localPath as NSString).appendingPathExtension("txt")!
                books.append(BookModel(name: name, localPath: URL(fileURLWithPath: localPath), lastAccessDate: lastAccess, progress: progress))
            })
        }
        return books.sorted { (v1, v2) -> Bool in
            v1.lastAccessDate > v2.lastAccessDate
        }
    }
    
    // 将书籍保存到数据库
    func addBook(_ name: String) {
        safeQueue.inDatabase { db in
            try? db.executeUpdate(statment: "INSERT OR REPLACE INTO book_list (name) VALUES (?);", doBindings: { stmt in
                try? stmt.bind(position: 1, name)
            })
        }
    }
    
    // 将书籍从数据库删除
    func removeBook(_ name: String) {
        safeQueue.inDatabase { db in
            try? db.executeUpdate(statment: "DELETE FROM book_list WHERE name=?;", doBindings: { stmt in
                try? stmt.bind(position: 1, name)
            })
        }
    }
    
    // 保存最近一次看书时间
    func save(_ accessDate: Double, forBook name: String) {
        safeQueue.inDatabase { db in
            try? db.executeUpdate(statment: "UPDATE book_list SET last_access=? WHERE name=?", doBindings: { stmt in
                try? stmt.bind(position: 1, accessDate)
                try? stmt.bind(position: 2, name)
            })
        }
    }
    
    // 获取页码
    func pageLocation(forBook name: String) -> PageLocation {
        var location = PageLocation()
        safeQueue.inDatabase { db in
            try? db.executeQuery(statement: "SELECT chapter_index, subrange_index, progress FROM book_list WHERE name=?;", doBindings: { stmt in
                try? stmt.bind(position: 1, name)
            }, handleRow: { stmt, stop in
                location.chapterIndex = stmt.columnInt(position: 0)
                location.subrangeIndex = stmt.columnInt(position: 1)
                location.progress = stmt.columnDouble(position: 2)
                stop.pointee = true
            })
        }
        return location
    }
    
    // 保存页码
    func save(_ pageLocaiton: PageLocation, forBook name: String) {
        safeQueue.inDatabase { db in
            try? db.executeUpdate(statment: "UPDATE book_list SET chapter_index=?, subrange_index=?, progress=? WHERE name=?;", doBindings: { stmt in
                try? stmt.bind(position: 1, pageLocaiton.chapterIndex)
                try? stmt.bind(position: 2, pageLocaiton.subrangeIndex)
                try? stmt.bind(position: 3, pageLocaiton.progress)
                try? stmt.bind(position: 4, name)
            })
        }
    }
    
    func removePageLocation(ofBook name: String) {
        safeQueue.inDatabase { db in
            try? db.executeUpdate(statment: "DELETE FROM book_list WHERE name=?;", doBindings: { stmt in
                try? stmt.bind(position: 1, name)
            })
        }
    }
}

struct PageLocation {
    var chapterIndex: Int = 0
    var subrangeIndex: Int = 0
    var progress: Double = 0
}
