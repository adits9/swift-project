//
//  StaffDirectoryRepository.swift
//  PocketPad
//
//  Repository for Staff Directory operations
//

import Foundation
import GRDB

class StaffDirectoryRepository {
    static let shared = StaffDirectoryRepository()
    
    private var db: DatabaseQueue {
        DatabaseManager.shared.database
    }
    
    private init() {}
    
    // MARK: - Operations
    
    func getAllStaff() throws -> [StaffDirectoryEntry] {
        try db.read { db in
            try StaffDirectoryEntry.order(Column("name")).fetchAll(db)
        }
    }
    
    func searchStaff(query: String) throws -> [StaffDirectoryEntry] {
        try db.read { db in
            let pattern = "%\(query)%"
            return try StaffDirectoryEntry
                .filter(Column("name").like(pattern) || Column("email").like(pattern) || Column("role").like(pattern) || Column("subjectTaught").like(pattern))
                .order(Column("name"))
                .fetchAll(db)
        }
    }
    
    func getStaffByRole(_ role: String) throws -> [StaffDirectoryEntry] {
        try db.read { db in
            try StaffDirectoryEntry
                .filter(Column("role") == role)
                .order(Column("name"))
                .fetchAll(db)
        }
    }
}
