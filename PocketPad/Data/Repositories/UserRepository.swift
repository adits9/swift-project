//
//  UserRepository.swift
//  PocketPad
//
//  Repository for User CRUD operations
//

import Foundation
import GRDB
import CryptoKit

class UserRepository {
    static let shared = UserRepository()
    
    private var db: DatabaseQueue {
        DatabaseManager.shared.database
    }
    
    private init() {}
    
    // MARK: - CRUD Operations
    
    func createUser(username: String, email: String, password: String, fullName: String) throws -> User {
        let passwordHash = hashPassword(password)
        let user = User(
            username: username,
            email: email,
            passwordHash: passwordHash,
            fullName: fullName
        )
        
        try db.write { db in
            try user.insert(db)
        }
        
        return user
    }
    
    func getUser(byId id: String) throws -> User? {
        try db.read { db in
            try User.fetchOne(db, key: id)
        }
    }
    
    func getUser(byUsername username: String) throws -> User? {
        try db.read { db in
            try User.filter(Column("username") == username).fetchOne(db)
        }
    }
    
    func getUser(byEmail email: String) throws -> User? {
        try db.read { db in
            try User.filter(Column("email") == email).fetchOne(db)
        }
    }
    
    func authenticate(username: String, password: String) throws -> User? {
        guard let user = try getUser(byUsername: username) else {
            return nil
        }
        
        let passwordHash = hashPassword(password)
        return passwordHash == user.passwordHash ? user : nil
    }
    
    func deleteUser(_ user: User) throws {
        try db.write { db in
            try user.delete(db)
        }
    }
    
    // MARK: - Password Hashing
    
    private func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
