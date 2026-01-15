//
//  DatabaseManager.swift
//  PocketPad
//
//  Central database management using GRDB
//

import Foundation
import GRDB

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var dbQueue: DatabaseQueue?
    
    private init() {}
    
    func setupDatabase() {
        do {
            let fileManager = FileManager.default
            let appSupportURL = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            let dbURL = appSupportURL.appendingPathComponent(Config.databaseName)
            
            dbQueue = try DatabaseQueue(path: dbURL.path)
            
            try migrator.migrate(dbQueue!)
            
            // Seed initial data
            try seedInitialData()
            
            print("✅ Database initialized at: \(dbURL.path)")
        } catch {
            fatalError("Failed to setup database: \(error)")
        }
    }
    
    var database: DatabaseQueue {
        guard let queue = dbQueue else {
            fatalError("Database not initialized. Call setupDatabase() first.")
        }
        return queue
    }
    
    // MARK: - Migrations
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        // v1: Initial schema
        migrator.registerMigration("v1_initial_schema") { db in
            // Users table
            try db.create(table: "users") { t in
                t.column("id", .text).primaryKey()
                t.column("username", .text).notNull().unique()
                t.column("email", .text).notNull().unique()
                t.column("passwordHash", .text).notNull()
                t.column("fullName", .text).notNull()
                t.column("createdAt", .datetime).notNull()
            }
            
            // Schedule entries table
            try db.create(table: "schedule_entries") { t in
                t.column("id", .text).primaryKey()
                t.column("userId", .text).notNull().references("users", onDelete: .cascade)
                t.column("period", .text).notNull()
                t.column("subject", .text).notNull()
                t.column("room", .text).notNull()
                t.column("teacher", .text).notNull()
                t.column("dayType", .text).notNull().defaults(to: "Regular")
                t.column("createdAt", .datetime).notNull()
            }
            
            // Lunch menu items table
            try db.create(table: "lunch_menu_items") { t in
                t.column("id", .text).primaryKey()
                t.column("date", .datetime).notNull()
                t.column("mainDish", .text).notNull()
                t.column("sides", .text).notNull() // JSON array
                t.column("dessert", .text)
                t.column("vegetarianOption", .text)
            }
            
            // Extracurriculars table
            try db.create(table: "extracurriculars") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("description", .text).notNull()
                t.column("meetingTime", .text).notNull()
                t.column("location", .text).notNull()
                t.column("contactEmail", .text).notNull()
                t.column("category", .text).notNull()
            }
            
            // Staff directory table
            try db.create(table: "staff_directory") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("email", .text).notNull()
                t.column("role", .text).notNull()
                t.column("department", .text)
                t.column("subjectTaught", .text)
                t.column("phoneExtension", .text)
            }
            
            // User favorites table
            try db.create(table: "user_favorites") { t in
                t.column("id", .text).primaryKey()
                t.column("userId", .text).notNull().references("users", onDelete: .cascade)
                t.column("itemType", .text).notNull()
                t.column("itemId", .text).notNull()
                t.column("createdAt", .datetime).notNull()
                t.uniqueKey(["userId", "itemType", "itemId"])
            }
        }
        
        return migrator
    }
    
    // MARK: - Seed Data
    
    private func seedInitialData() throws {
        try database.write { db in
            // Check if data already exists
            let extracurricularCount = try Extracurricular.fetchCount(db)
            let staffCount = try StaffDirectoryEntry.fetchCount(db)
            
            if extracurricularCount == 0 {
                try seedExtracurriculars(db)
            }
            
            if staffCount == 0 {
                try seedStaffDirectory(db)
            }
        }
    }
    
    private func seedExtracurriculars(_ db: Database) throws {
        let extracurriculars = [
            Extracurricular(
                name: "Robotics Club",
                description: "Design, build, and program robots for competitions",
                meetingTime: "Wednesdays 3:30 PM - 5:00 PM",
                location: "Room 205, Engineering Lab",
                contactEmail: "robotics@jeffersonhigh.edu",
                category: "STEM"
            ),
            Extracurricular(
                name: "Drama Club",
                description: "Theater performances, acting workshops, and stage production",
                meetingTime: "Tuesdays and Thursdays 3:30 PM - 5:30 PM",
                location: "Auditorium",
                contactEmail: "drama@jeffersonhigh.edu",
                category: "Arts"
            ),
            Extracurricular(
                name: "Debate Team",
                description: "Competitive debate and public speaking",
                meetingTime: "Mondays 4:00 PM - 6:00 PM",
                location: "Room 312",
                contactEmail: "debate@jeffersonhigh.edu",
                category: "Academic"
            ),
            Extracurricular(
                name: "Environmental Club",
                description: "Campus sustainability projects and environmental advocacy",
                meetingTime: "Fridays 3:30 PM - 4:30 PM",
                location: "Room 108, Science Building",
                contactEmail: "green@jeffersonhigh.edu",
                category: "Service"
            ),
            Extracurricular(
                name: "Soccer Team",
                description: "Varsity and JV soccer practices and competitions",
                meetingTime: "Mon-Fri 3:30 PM - 5:30 PM",
                location: "Athletic Field",
                contactEmail: "soccer@jeffersonhigh.edu",
                category: "Sports"
            ),
            Extracurricular(
                name: "Chess Club",
                description: "Learn strategies and compete in tournaments",
                meetingTime: "Thursdays 3:30 PM - 5:00 PM",
                location: "Library",
                contactEmail: "chess@jeffersonhigh.edu",
                category: "Academic"
            )
        ]
        
        for activity in extracurriculars {
            try activity.insert(db)
        }
    }
    
    private func seedStaffDirectory(_ db: Database) throws {
        let staffMembers = [
            StaffDirectoryEntry(
                name: "Dr. Sarah Johnson",
                email: "sjohnson@jeffersonhigh.edu",
                role: "Teacher",
                department: "Mathematics",
                subjectTaught: "Calculus, Algebra",
                phoneExtension: "2301"
            ),
            StaffDirectoryEntry(
                name: "Mr. Michael Chen",
                email: "mchen@jeffersonhigh.edu",
                role: "Teacher",
                department: "Science",
                subjectTaught: "Physics, Chemistry",
                phoneExtension: "2305"
            ),
            StaffDirectoryEntry(
                name: "Ms. Emily Rodriguez",
                email: "erodriguez@jeffersonhigh.edu",
                role: "Teacher",
                department: "English",
                subjectTaught: "English Literature, Creative Writing",
                phoneExtension: "2310"
            ),
            StaffDirectoryEntry(
                name: "Mr. David Thompson",
                email: "dthompson@jeffersonhigh.edu",
                role: "Teacher",
                department: "History",
                subjectTaught: "U.S. History, World History",
                phoneExtension: "2315"
            ),
            StaffDirectoryEntry(
                name: "Mrs. Lisa Anderson",
                email: "landerson@jeffersonhigh.edu",
                role: "Counselor",
                department: "Guidance",
                phoneExtension: "2201"
            ),
            StaffDirectoryEntry(
                name: "Dr. Robert Martinez",
                email: "rmartinez@jeffersonhigh.edu",
                role: "Administrator",
                department: "Administration",
                phoneExtension: "2001"
            )
        ]
        
        for staff in staffMembers {
            try staff.insert(db)
        }
    }
}
