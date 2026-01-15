//
//  StaffDirectoryEntry.swift
//  PocketPad
//
//  Staff directory entry data model
//

import Foundation
import GRDB

struct StaffDirectoryEntry: Codable, Identifiable {
    var id: String
    var name: String
    var email: String
    var role: String // "Teacher", "Counselor", "Administrator", etc.
    var department: String?
    var subjectTaught: String?
    var phoneExtension: String?
    
    init(id: String = UUID().uuidString,
         name: String,
         email: String,
         role: String,
         department: String? = nil,
         subjectTaught: String? = nil,
         phoneExtension: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.department = department
        self.subjectTaught = subjectTaught
        self.phoneExtension = phoneExtension
    }
}

// MARK: - GRDB Conformance
extension StaffDirectoryEntry: FetchableRecord, PersistableRecord {
    static let databaseTableName = "staff_directory"
}
