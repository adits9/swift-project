//
//  ExtracurricularRepository.swift
//  PocketPad
//
//  Repository for Extracurricular operations
//

import Foundation
import GRDB

class ExtracurricularRepository {
    static let shared = ExtracurricularRepository()
    
    private var db: DatabaseQueue {
        DatabaseManager.shared.database
    }
    
    private init() {}
    
    // MARK: - Operations
    
    func getAllExtracurriculars() throws -> [Extracurricular] {
        try db.read { db in
            try Extracurricular.order(Column("name")).fetchAll(db)
        }
    }
    
    func searchExtracurriculars(query: String) throws -> [Extracurricular] {
        try db.read { db in
            let pattern = "%\(query)%"
            return try Extracurricular
                .filter(Column("name").like(pattern) || Column("description").like(pattern) || Column("category").like(pattern))
                .order(Column("name"))
                .fetchAll(db)
        }
    }
    
    func getExtracurricular(byId id: String) throws -> Extracurricular? {
        try db.read { db in
            try Extracurricular.fetchOne(db, key: id)
        }
    }
    
    func addFavorite(userId: String, extracurricularId: String) throws {
        let favorite = UserFavorite(
            userId: userId,
            itemType: "extracurricular",
            itemId: extracurricularId
        )
        
        try db.write { db in
            try favorite.insert(db)
        }
    }
    
    func removeFavorite(userId: String, extracurricularId: String) throws {
        try db.write { db in
            try UserFavorite
                .filter(Column("userId") == userId && Column("itemType") == "extracurricular" && Column("itemId") == extracurricularId)
                .deleteAll(db)
        }
    }
    
    func isFavorite(userId: String, extracurricularId: String) throws -> Bool {
        try db.read { db in
            let count = try UserFavorite
                .filter(Column("userId") == userId && Column("itemType") == "extracurricular" && Column("itemId") == extracurricularId)
                .fetchCount(db)
            return count > 0
        }
    }
    
    func getFavorites(forUserId userId: String) throws -> [Extracurricular] {
        try db.read { db in
            let favoriteIds = try UserFavorite
                .filter(Column("userId") == userId && Column("itemType") == "extracurricular")
                .fetchAll(db)
                .map { $0.itemId }
            
            return try Extracurricular
                .filter(favoriteIds.contains(Column("id")))
                .order(Column("name"))
                .fetchAll(db)
        }
    }
}
