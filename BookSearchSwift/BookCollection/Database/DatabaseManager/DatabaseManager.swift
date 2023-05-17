//
//  DatabaseManager.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 11/17/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import SQLite3
import Foundation

// MARK: - Custom Enum of Type Error
enum SqliteError: Error {
    
    case invalidDirecotyUrl
    case openDBFailed
    case prepareFailed
    case stepFailed
    case bindFailed
    case invalidBundleUrl
    case copyFailed
    case tableCreationFailed
    case insertSQLiteFailed
    case deleteFailed
    case updateFailed
    case readFailed
    case deleteAllFailed
}

// MARK: - Protocol for Data Provider
protocol DatabaseProvider {
    func insert(volume: VolumeInfoModel) throws
    func delete(whereId pKey: Int32) throws
    func update(volume: VolumeInfoModel, whereId pKey: Int) throws
    func read() throws -> [VolumeInfoModel]
    func insertUsers(volumes: [VolumeInfoModel]) throws
    
    init(dbName: String)
    
    var dbPath: String { get }
    var dbName: String { get }
}

// MARK: - Data Base Handler class created
class DBManager: DatabaseProvider {
   
    var dbPath: String = ""
    var dbName: String
    var dbPointer: OpaquePointer?
    static let shared = DBManager()
    
    // MARK: - Construction(Init)
    internal required init(dbName: String = "StoredBooksInfo.db") {
        self.dbName = dbName
    }
    
    func startDB() {
        try? self.createDBIfRequired()
        self.dbPointer = try? self.openConnection()
        try? createTableIfRequired()
    }
    
    // MARK: - Create Dadat Base IF Required
    private func createDBIfRequired() throws {
        // Get the docs directory
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { throw SqliteError.invalidDirecotyUrl }
        self.dbPath = docDirectory.appendingPathComponent(self.dbName).path
        do {
            try self.copyDatabaseIntoDocumetsDirectoryIfNeeded(addDestination: self.dbPath)
        } catch let error as SqliteError {
            throw error
        }
    }
    
    // MARK: - Copy Data Base If Needed
    func copyDatabaseIntoDocumetsDirectoryIfNeeded(addDestination destPath: String) throws {
        guard let bundleUrl = Bundle.main.resourceURL?.appendingPathComponent(self.dbName) else {
            throw SqliteError.invalidBundleUrl
        }
        if FileManager.default.fileExists(atPath: destPath) {
            print("Document File Already Exist")
            print(destPath)
        } else if FileManager.default.fileExists(atPath: bundleUrl.path) {
            do {
                print(destPath)
                try FileManager.default.copyItem(atPath: bundleUrl.path, toPath: destPath)
            } catch {
                throw SqliteError.copyFailed
            }
        }
    }
    
    // MARK: - Open DB Connection
    func openConnection() throws -> OpaquePointer? {
        // opquePointer is required to access the db or interact
        var opaquePointer: OpaquePointer? // It's Swift type for C pointer.
        if sqlite3_open(self.dbPath, &opaquePointer) == SQLITE_OK {
            print("Success Open Connection DB")
            return opaquePointer
            
        } else {
            print("Faild to open connection DB")
            throw SqliteError.openDBFailed
        }
    }
    
    // MARK: - Close DB Connection
    func closeConnection() {
        sqlite3_close(self.dbPointer)
    }
    
    // MARK: - Create DB Table If does not exist
    func createTableIfRequired() throws {
                
     let createTableQuery = """
        CREATE TABLE IF NOT EXISTS "BookInfo" (
                    "Title" TEXT,
                    "Authors" TEXT,
                    "Subtitle" TEXT,
                    "Page Count" INTEGER,
                    "Publisher" TEXT,
                    "Published Date" TEXT,
                    "Description" TEXT,
                    "Average Rating" REAL,
                    "Ratings Count" INTEGER,
                    "Language" TEXT,
                    "Preview Link" TEXT,
                    "Book Image Url" TEXT,
                    "Id" INTEGER NOT NULL UNIQUE,
                PRIMARY KEY("Id" AUTOINCREMENT)
             );
        """

        let dbHandler = try self.prepareStatement(sql: createTableQuery)
        
        defer {
            // Finalize deletes the compiled statement to avoid memory licked
            sqlite3_finalize(dbHandler)
        }
        guard sqlite3_step(dbHandler) == SQLITE_DONE else {
            print("Table no Created\n**Throw error**")
            throw SqliteError.tableCreationFailed
        }
        print("Created table Success")
    }
    
    // MARK: - Prepare DB
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var localPointer: OpaquePointer?
        if sqlite3_prepare_v2(self.dbPointer, sql, -1, &localPointer, nil) == SQLITE_OK {
            return localPointer
            
        } else {
            throw SqliteError.prepareFailed
        }
    }
    
    // MARK: - Destructor(deinit)
    deinit {
        sqlite3_close(self.dbPointer)
    }
}

extension DBManager {
    
    func insertUsers(volumes: [VolumeInfoModel]) throws {
        for  volume in volumes {
            try self.insert(volume: volume)
        }
    }

    // MARK: - Insert UserInfo Row into DB Table
    func insert(volume: VolumeInfoModel) throws {
        let query = """
        INSERT INTO BookInfo (  Title,
                                Authors,
                                Subtitle,
                                `Page Count`,
                                Publisher,
                                `Published Date`,
                                Description,
                                `Average Rating`,
                                `Ratings Count`,
                                Language,
                                `Preview Link`,
                                `Book Image Url`)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """

        let statement = try self.prepareStatement(sql: query)
        defer {
            sqlite3_finalize(statement)
        }
        guard sqlite3_bind_text(statement, 1, ((volume.title ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
              sqlite3_bind_text(statement, 2, ((volume.authors ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(statement, 3, ((volume.subtitle ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_int(statement, 4, Int32(volume.pageCount ?? 0)) == SQLITE_OK &&
                sqlite3_bind_text(statement, 5, ((volume.publisher ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(statement, 6, ((volume.publishedDate ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(statement, 7, ((volume.description ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_double(statement, 8, volume.averageRating ?? 0.0 ) == SQLITE_OK &&
                sqlite3_bind_int(statement, 9, Int32(volume.ratingsCount ?? 0)) == SQLITE_OK &&
                sqlite3_bind_text(statement, 10, ((volume.language ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(statement, 11, ((volume.previewLink ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(statement, 12, ((volume.bookImageUrl ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK else {
            throw SqliteError.bindFailed
        }
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SqliteError.insertSQLiteFailed
        }
        print("Values written Successfully")
    }
    // MARK: - Delete All Rows in DB Table
    func deleteAll() throws {
        let query = "DELETE FROM BookInfo"
        let statement = try self.prepareStatement(sql: query)
        defer {
            sqlite3_finalize(statement)
        }
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SqliteError.deleteAllFailed
        }
        print("All Value deleted Succeessfully")
    }
    
    // MARK: - Delete A Row By Id in Table
    func delete(whereId pKey: Int32) throws {
        let query = "DELETE FROM BookInfo WHERE Id = ?;"
        let statement = try self.prepareStatement(sql: query)
        guard sqlite3_bind_int(statement, 1, pKey) == SQLITE_OK else { throw SqliteError.bindFailed }
        
        defer {
            sqlite3_finalize(statement)
            print("Deleted volume with id: \(pKey)")
        }
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SqliteError.deleteFailed
        }
        print("Value deleted Succeessfully")
    }
    
    // MARK: - Update Rows in Table
    func update(volume: VolumeInfoModel, whereId pKey: Int) throws {
  
        let query = """
        UPDATE BookInfo
        SET `Title` = '\(volume.title ?? "")',
            `Authors` = '\(volume.authors ?? "")',
            `Subtitle` = '\(volume.subtitle ?? "")',
            `Page Count` = '\(volume.pageCount ?? 0)',
            `Publisher` = '\(volume.publisher ?? "")',
            `Published Date` = '\(volume.publishedDate ?? "")',
            `Description` = '\(volume.description ?? "")',
            `Averate Rating` '\(volume.averageRating ?? 0.0)',
            `Ratings Count` = '\(volume.ratingsCount ?? 0)',
            `Language` = '\(volume.language ?? "")',
            `Preview Link` = '\(volume.previewLink ?? "")',
            `Book Image Url` = '\(volume.previewLink ?? "")'

        WHERE Id = \(pKey)
        """

        let statement = try self.prepareStatement(sql: query)
        defer {
            sqlite3_finalize(statement)
        }
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SqliteError.updateFailed
        }
        print("updated Value Succeessfully")
    }
    
    // MARK: - Read Al Rows From Table
    func read() throws -> [VolumeInfoModel] {
        print("read")
        let query = "SELECT * FROM BookInfo;"
        let statement = try self.prepareStatement(sql: query)
        var volumes = [VolumeInfoModel]()
        while sqlite3_step(statement) == SQLITE_ROW {
            print("reading rows")
            let title = String(describing: String(cString: sqlite3_column_text(statement, 0)))
            let authors = String(describing: String(cString: sqlite3_column_text(statement, 1)))
            let subtitle = String(describing: String(cString: sqlite3_column_text(statement, 2)))
            
            let pageCount = Int(sqlite3_column_int(statement, 3))
            
            let publisher = String(describing: String(cString: sqlite3_column_text(statement, 4)))
            let publishedDate = String(describing: String(cString: sqlite3_column_text(statement, 5)))
            let description = String(describing: String(cString: sqlite3_column_text(statement, 6)))
            
            let avgRating = sqlite3_column_double(statement, 7)
            let ratingCount = Int(sqlite3_column_int(statement, 8))
            
            let language = String(describing: String(cString: sqlite3_column_text(statement, 9)))
            let priviewLink = String(describing: String(cString: sqlite3_column_text(statement, 10)))
            let bookImageUrl = String(describing: String(cString: sqlite3_column_text(statement, 11)))

            let pId = sqlite3_column_int(statement, 12)
            var volume = VolumeInfoModel(volume: nil)
            volume.identifier = pId
            volume.authors = authors
            volume.title = title
            volume.subtitle = subtitle
            volume.pageCount = pageCount
            volume.publisher = publisher
            volume.publishedDate = publishedDate
            volume.description = description
            volume.averageRating = avgRating
            volume.ratingsCount = ratingCount
            volume.language = language
            volume.previewLink = priviewLink
            volume.bookImageUrl = bookImageUrl
            volumes.append(volume)
        }
        print("read Data Successfully")
        return volumes
    }
}
