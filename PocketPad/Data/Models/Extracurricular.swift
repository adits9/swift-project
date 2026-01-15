//
//  Extracurricular.swift
//  PocketPad
//
//  Extracurricular activity data model
//

import Foundation
import GRDB

struct Extracurricular: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var meetingTime: String
    var location: String
    var contactEmail: String
    var category: String // "Sports", "Arts", "Academic", "Service", etc.
    
    init(id: String = UUID().uuidString,
         name: String,
         description: String,
         meetingTime: String,
         location: String,
         contactEmail: String,
         category: String) {
        self.id = id
        self.name = name
        self.description = description
        self.meetingTime = meetingTime
        self.location = location
        self.contactEmail = contactEmail
        self.category = category
    }
}

// MARK: - GRDB Conformance
extension Extracurricular: FetchableRecord, PersistableRecord {
    static let databaseTableName = "extracurriculars"
}
