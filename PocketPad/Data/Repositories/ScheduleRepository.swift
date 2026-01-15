//
//  ScheduleRepository.swift
//  PocketPad
//
//  Repository for Schedule CRUD operations
//

import Foundation
import GRDB

class ScheduleRepository {
    static let shared = ScheduleRepository()
    
    private var db: DatabaseQueue {
        DatabaseManager.shared.database
    }
    
    private init() {}
    
    // MARK: - CRUD Operations
    
    func createScheduleEntry(_ entry: ScheduleEntry) throws {
        try db.write { db in
            try entry.insert(db)
        }
    }
    
    func getScheduleEntries(forUserId userId: String, dayType: String = "Regular") throws -> [ScheduleEntry] {
        try db.read { db in
            try ScheduleEntry
                .filter(Column("userId") == userId && Column("dayType") == dayType)
                .order(Column("period"))
                .fetchAll(db)
        }
    }
    
    func updateScheduleEntry(_ entry: ScheduleEntry) throws {
        try db.write { db in
            try entry.update(db)
        }
    }
    
    func deleteScheduleEntry(_ entry: ScheduleEntry) throws {
        try db.write { db in
            try entry.delete(db)
        }
    }
    
    func deleteAllScheduleEntries(forUserId userId: String) throws {
        try db.write { db in
            try ScheduleEntry
                .filter(Column("userId") == userId)
                .deleteAll(db)
        }
    }
}
