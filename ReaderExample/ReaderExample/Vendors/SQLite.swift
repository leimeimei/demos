//
//  SQLite.swift
//  ReaderExample
//
//  Created by sun on 2021/12/27.
//

import Foundation
import SQLite3

struct SQLiteError: Error {
    let code: Int32
    let description: String
    var localizedDescription: String {
        description
    }
    init(code: Int32, description: String) {
        self.code = code
        self.description = description
    }
}

enum SQLiteTransaction {
    case exclusive
    case deferred
    case immediate
}

private let kSQLiteQueuekey: DispatchSpecificKey<SQLiteQueue> = DispatchSpecificKey()

class SQLiteQueue {
    private lazy var serialQueue = DispatchQueue(label: "SQLite serial queue")
    private let db: SQLiteDatabase
    
    init(_ path: String, readOnly: Bool = false, busyTimeoutMillis: Int = 600000, openWAL: Bool = true) throws {
        self.db = try SQLiteDatabase(path, readOnly: readOnly, busyTimeoutMillis: busyTimeoutMillis)
        serialQueue.setSpecific(key: kSQLiteQueuekey, value: self)
        
    }
    func inDatabase(_ exec: @escaping (SQLiteDatabase) -> Void) {
        #if NDEUG
        let currentQueue = serialQueue.getSpecific(key: kSQLiteQueuekey)
        assert(currentQueue !== self, "inDatabase: was called reentrantly on the same queue, which would lead to a deadlock")
        #endif
        serialQueue.sync {
            exec(self.db)
        }
    }
    func inTransaction(_ transaction: SQLiteTransaction = .exclusive, _ exec: @escaping (_ db: SQLiteDatabase, _ rollback:UnsafeMutablePointer<Bool>) throws -> Void) {
        #if NDEBUG
            let currentQueue = serialQueue.getSpecific(key: kSQLiteQueuekey)
            assert(currentQueue !== self, "inDatabase: was called reentrantly on the same queue, which would lead to a deadlock")
        #endif
        serialQueue.sync {
            switch transaction {
            case .exclusive:
                try? self.db.execute(sql: "BEGIN EXCLUSIVE TRANSACTION")
            case .deferred:
                try? self.db.execute(sql: "BEGIN DEFERRED TRANSACTION")
            case .immediate:
                try? self.db.execute(sql: "BEGIN IMMEDIATE TRANSACTION")
            }
            
            var rollback = false
            do {
                try exec(self.db, &rollback)
                if rollback {
                    try self.db.execute(sql: "ROLLBACK TRANSACTION")
                } else {
                    try self.db.execute(sql: "COMMIT TRANSACTION")
                }
            } catch {
                try? self.db.execute(sql: "ROLLBACK TRANSACTION")
            }
        }
    }
    deinit {
        #if NDEBUG
            let currentQueue = serialQueue.getSpecific(key: kSQLiteQueuekey)
            assert(currentQueue !== self, "inDatabase: was called reentrantly on the same queue, which would lead to a deadlock")
        #endif
        serialQueue.sync {
            try? self.db.close()
        }
    }
}

class SQLiteDatabase {
    let path: String
    private var db = OpaquePointer(bitPattern: 0)
    
    init(_ path: String, readOnly: Bool = false, busyTimeoutMillis: Int = 600000) throws {
        self.path = path
        let flags = readOnly ? SQLITE_OPEN_READONLY : (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
        
        let res = sqlite3_open_v2(path, &self.db, flags, nil)
        if res != SQLITE_OK {
            throw SQLiteError(code: res, description: "Unable to open databse" + path)
        }
        sqlite3_busy_timeout(self.db, Int32(busyTimeoutMillis))
    }
    
    func close() throws {
        if self.db != nil {
            var res: Int32 = 0
            var stmtFinalized = false
            var retry = false
            repeat {
                retry = false
                res = sqlite3_close_v2(self.db)
                if res == SQLITE_BUSY || res == SQLITE_LOCKED {
                    if !stmtFinalized {
                        var stmt: OpaquePointer?
                        stmt = sqlite3_next_stmt(self.db, nil)
                        while stmt != nil {
                            sqlite3_finalize(stmt)
                            retry = true
                            stmt = sqlite3_next_stmt(self.db, nil)
                        }
                        stmtFinalized = true
                    }
                } else if res != SQLITE_OK {
                    throw SQLiteError(code: res, description: "Unable to close database" + path)
                }
            } while retry
            self.db = nil
        }
    }
    func close<T>(after: (SQLiteDatabase) -> T) -> T {
        defer { try? close() }
        return after(self)
    }
    deinit {
        try? close()
    }
}

extension SQLiteDatabase {
    
    func prepare(statement stat: String) throws -> SQLiteStmt {
        var statPtr = OpaquePointer(bitPattern: 0)
        let res = sqlite3_prepare(self.db, stat, Int32(stat.utf8.count), &statPtr, nil)
        if res != SQLITE_OK {
            throw SQLiteError(code: res, description: String(cString: sqlite3_errmsg(self.db)))
        }
        return SQLiteStmt(db: db!, stat: statPtr!)
    }
    
    func execute(sql: String) throws {
        let res = sqlite3_exec(self.db, sql, nil, nil, nil)
        if res != SQLITE_OK {
            throw SQLiteError(code: res, description: String(cString: sqlite3_errmsg(self.db)))
        }
    }
    
    func executeUpdate(statment: String, doBindings: (SQLiteStmt) throws -> Void) throws {
        let stat = try prepare(statement: statment)
        defer { stat.finalize() }
        try doBindings(stat)
        let res = stat.step()
        if res != SQLITE_DONE {
            throw SQLiteError(code: res, description: String(cString: sqlite3_errmsg(self.db)))
        }
    }
    
    func executeQuery(statement: String, doBindings: (SQLiteStmt) throws -> Void, handleRow: (_ stmt: SQLiteStmt, _ stop: UnsafeMutablePointer<Bool>) throws -> Void) throws {
        let stat = try prepare(statement: statement)
        defer { stat.finalize() }
        
        try doBindings(stat)
        var res = stat.step()
        var stop = false
        while res == SQLITE_ROW {
            if stop == true { return }
            try handleRow(stat, &stop)
            res = stat.step()
        }
        if res != SQLITE_DONE {
            throw SQLiteError(code: res, description: String(cString: sqlite3_errmsg(self.db)))
        }
    }
    
    func doWithTransaction(_ transaction: SQLiteTransaction, _ closure: (SQLiteDatabase) throws -> Void) {
        switch transaction {
        case .exclusive:
            try? execute(sql: "BEGIN EXCLUSIVE TRANSACTION")
        case .deferred:
            try? execute(sql: "BEGIN DEFERRED TRANSACTION")
        case .immediate:
            try? execute(sql: "BEGIN IMMEDIATE TRANSACTION")
        }
        do {
            try closure(self)
            try execute(sql: "COMMIT TRANSACTION")
        } catch {
            try? execute(sql: "ROLLBACK TRANSACTION")
        }
    }
    
    func lastInsertRowID() -> Int {
        let res = sqlite3_last_insert_rowid(self.db)
        return Int(res)
    }
    
    func totalChanges() -> Int {
        let res = sqlite3_total_changes(self.db)
        return Int(res)
    }
    
    func change() -> Int {
        let res = sqlite3_changes(self.db)
        return Int(res)
    }
    
    func errCode() -> Int {
        let res = sqlite3_errcode(self.db)
        return Int(res)
    }
    
    func errMsg() -> String {
        let cMsg = sqlite3_errmsg(self.db)
        return String(cString: cMsg!)
    }
}

enum SQLiteType: Int32 {
    case integer = 1
    case float = 2
    case text = 3
    case blob = 4
    case null = 5
}

class SQLiteStmt {
    let db :OpaquePointer?
    var stat :OpaquePointer!
    
    init(db: OpaquePointer?, stat: OpaquePointer) {
        self.db = db
        self.stat = stat
    }
    
    func reset() throws -> Int32 {
        let res = sqlite3_reset(self.stat)
        try _checkResult(res)
        return res
    }
    
    fileprivate func finalize() {
        if self.stat != nil {
            sqlite3_finalize(self.stat!)
            self.stat = nil
        }
    }
    
    fileprivate func step() -> Int32 {
        sqlite3_step(stat)
    }
    
    func bind(position: Int, _ d: Double) throws {
        try _checkResult(sqlite3_bind_double(self.stat, Int32(position), d))
    }
    
    func bind(position: Int, _ i: Int32) throws {
        try _checkResult(sqlite3_bind_int(self.stat, Int32(position), i))
    }
    
    func bind(position: Int, _ i: Int) throws {
        try _checkResult(sqlite3_bind_int64(self.stat, Int32(position), Int64(i)))
    }
    
    func bind(position: Int, _ s: String) throws {
        try _checkResult(sqlite3_bind_text(self.stat, Int32(position), s, Int32(s.utf8.count), unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)))
    }
    
    func bind(position: Int, _ b: [Int8]) throws {
        try _checkResult(sqlite3_bind_blob(self.stat, Int32(position), b, Int32(b.count), unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)))
    }
    
    func bind(position: Int, _ b: [UInt8]) throws {
        try _checkResult(sqlite3_bind_blob(self.stat, Int32(position), b, Int32(b.count), unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)))
    }
    
    func bindZeroBlob(position: Int, count: Int) throws {
        try _checkResult(sqlite3_bind_zeroblob(self.stat, Int32(position), Int32(count)))
    }
    
    func bindNull(position: Int) throws {
        try _checkResult(sqlite3_bind_null(self.stat, Int32(position)))
    }
    
    /*  */
    
    func bind(name: String, _ d: Double) throws {
        try _checkResult(sqlite3_bind_double(self.stat, bindParameterIndex(name: name), d))
    }
    
    func bind(name: String, _ i: Int32) throws {
        try _checkResult(sqlite3_bind_int(self.stat, bindParameterIndex(name: name), i))
    }
    
    func bind(name: String, _ i: Int) throws {
        try _checkResult(sqlite3_bind_int64(self.stat, bindParameterIndex(name: name), Int64(i)))
    }
    
    func bind(name: String, _ i: Int64) throws {
        try _checkResult(sqlite3_bind_int64(self.stat, bindParameterIndex(name: name), i))
    }
    
    func bind(name: String, _ s: String) throws {
        try _checkResult(sqlite3_bind_text(self.stat, bindParameterIndex(name: name), s, Int32(s.utf8.count), unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)))
    }
    
    func bind(name: String, _ b: [Int8]) throws {
        try _checkResult(sqlite3_bind_blob(self.stat, bindParameterIndex(name: name), b, Int32(b.count), unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)))
    }
    
    func bind(name: String, _ b: [UInt8]) throws {
        try _checkResult(sqlite3_bind_blob(self.stat, bindParameterIndex(name: name), b, Int32(b.count), unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)))
    }
    
    func bindZeroBlob(name: String, count: Int) throws {
        try _checkResult(sqlite3_bind_zeroblob(self.stat, bindParameterIndex(name: name), Int32(count)))
    }
    
    func bindNull(name: String) throws {
        try _checkResult(sqlite3_bind_null(self.stat, bindParameterIndex(name: name)))
    }
    
    /// :name
    func bindParameterIndex(name: String) throws -> Int32 {
        let idx = sqlite3_bind_parameter_index(self.stat, name)
        if idx == 0 {
            throw SQLiteError(code: SQLITE_MISUSE, description: "The indicated bind parameter name was not found.")
        }
        return idx
    }
    
    func columnName(position: Int) -> String {
        String(cString: sqlite3_column_name(self.stat, Int32(position)))
    }
    
    func columnDeclaredType(position: Int) -> String {
        return String(cString: sqlite3_column_decltype(self.stat, Int32(position)))
    }
    
    func columnType(position: Int) -> SQLiteType {
        let res = sqlite3_column_type(self.stat, Int32(position))
        return SQLiteType(rawValue: res)!
    }
    
    func columnCount() -> Int {
        let res = sqlite3_column_count(self.stat)
        return Int(res)
    }
    
    func columnIntBlob<I: BinaryInteger>(position: Int) -> [I] {
        let vp = sqlite3_column_blob(self.stat, Int32(position))
        let vpLen = Int(sqlite3_column_bytes(self.stat, Int32(position)))
        if vpLen <= 0 { return [] }
        
        var ret = [I]()
        if var bytesPtr = vp?.bindMemory(to: I.self, capacity: vpLen) {
            for _ in 0..<vpLen {
                ret.append(bytesPtr.pointee)
                bytesPtr = bytesPtr.successor()
            }
        }
        return ret
    }
    
    func columnText(position: Int) -> String {
        if let res = sqlite3_column_text(self.stat, Int32(position)) {
            return String(cString: res)
        }
        return ""
    }
    
    func columnDouble(position: Int) -> Double {
        return sqlite3_column_double(self.stat, Int32(position))
    }
    
    func columnInt32(position: Int) -> Int32 {
        return sqlite3_column_int(self.stat, Int32(position))
    }
    
    func columnInt(position: Int) -> Int {
        return Int(sqlite3_column_int64(self.stat, Int32(position)))
    }

    
    private func _checkResult(_ res: Int32) throws {
        if res != SQLITE_OK {
            throw SQLiteError(code: res, description: String(cString: sqlite3_errmsg(self.db)))
        }
    }
}
