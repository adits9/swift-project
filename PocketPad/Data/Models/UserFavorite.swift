//
//  UserFavorite.swift
//  PocketPad
//
//  User favorites (for extracurriculars, etc.)
//

import Foundation
import GRDB

struct UserFavorite: Codable, Identifiable {
    var id: String
    var userId: String
    var itemType: String // "extracurricular", etc.
    var itemId: String
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         userId: String,
         itemType: String,
         itemId: String,
         createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.itemType = itemType
        self.itemId = itemId
        self.createdAt = createdAt
    }
}

// MARK: - GRDB Conformance
extension UserFavorite: FetchableRecord, PersistableRecord {
    static let databaseTableName = "user_favorites"
}
