//
//  ScheduleEntry.swift
//  PocketPad
//
//  Schedule entry data model
//

import Foundation
import GRDB

struct ScheduleEntry: Codable, Identifiable {
    var id: String
    var userId: String
    var period: String
    var subject: String
    var room: String
    var teacher: String
    var dayType: String // "A", "B", or "Regular" - extensible for rotation
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         userId: String,
         period: String,
         subject: String,
         room: String,
         teacher: String,
         dayType: String = "Regular",
         createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.period = period
        self.subject = subject
        self.room = room
        self.teacher = teacher
        self.dayType = dayType
        self.createdAt = createdAt
    }
}

// MARK: - GRDB Conformance
extension ScheduleEntry: FetchableRecord, PersistableRecord {
    static let databaseTableName = "schedule_entries"
}
