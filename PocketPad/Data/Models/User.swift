//
//  User.swift
//  PocketPad
//
//  User data model
//

import Foundation
import GRDB

struct User: Codable, Identifiable {
    var id: String
    var username: String
    var email: String
    var passwordHash: String
    var fullName: String
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         username: String,
         email: String,
         passwordHash: String,
         fullName: String,
         createdAt: Date = Date()) {
        self.id = id
        self.username = username
        self.email = email
        self.passwordHash = passwordHash
        self.fullName = fullName
        self.createdAt = createdAt
    }
}

// MARK: - GRDB Conformance
extension User: FetchableRecord, PersistableRecord {
    static let databaseTableName = "users"
}
