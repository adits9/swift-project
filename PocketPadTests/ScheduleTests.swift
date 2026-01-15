//
//  ScheduleTests.swift
//  PocketPadTests
//
//  Unit tests for schedule CRUD operations
//

import XCTest
@testable import PocketPad

final class ScheduleTests: XCTestCase {
    var userRepository: UserRepository!
    var scheduleRepository: ScheduleRepository!
    var testUser: User!
    
    override func setUpWithError() throws {
        DatabaseManager.shared.setupDatabase()
        
        userRepository = UserRepository.shared
        scheduleRepository = ScheduleRepository.shared
        
        // Create a test user
        let username = "schedtest_\(UUID().uuidString.prefix(8))"
        testUser = try userRepository.createUser(
            username: username,
            email: "\(username)@test.com",
            password: "password123",
            fullName: "Schedule Test User"
        )
    }
    
    override func tearDownWithError() throws {
        // Clean up test user (cascade delete will remove schedule entries)
        if let user = testUser {
            try userRepository.deleteUser(user)
        }
        testUser = nil
        userRepository = nil
        scheduleRepository = nil
    }
    
    func testCreateScheduleEntry() throws {
        let entry = ScheduleEntry(
            userId: testUser.id,
            period: "Period 1",
            subject: "Mathematics",
            room: "Room 101",
            teacher: "Mr. Smith"
        )
        
        try scheduleRepository.createScheduleEntry(entry)
        
        let entries = try scheduleRepository.getScheduleEntries(forUserId: testUser.id)
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries.first?.subject, "Mathematics")
        XCTAssertEqual(entries.first?.room, "Room 101")
    }
    
    func testUpdateScheduleEntry() throws {
        var entry = ScheduleEntry(
            userId: testUser.id,
            period: "Period 2",
            subject: "Science",
            room: "Room 202",
            teacher: "Mrs. Johnson"
        )
        
        try scheduleRepository.createScheduleEntry(entry)
        
        // Update the entry
        entry.subject = "Biology"
        entry.room = "Room 203"
        try scheduleRepository.updateScheduleEntry(entry)
        
        let entries = try scheduleRepository.getScheduleEntries(forUserId: testUser.id)
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries.first?.subject, "Biology")
        XCTAssertEqual(entries.first?.room, "Room 203")
    }
    
    func testDeleteScheduleEntry() throws {
        let entry = ScheduleEntry(
            userId: testUser.id,
            period: "Period 3",
            subject: "English",
            room: "Room 303",
            teacher: "Ms. Davis"
        )
        
        try scheduleRepository.createScheduleEntry(entry)
        
        var entries = try scheduleRepository.getScheduleEntries(forUserId: testUser.id)
        XCTAssertEqual(entries.count, 1)
        
        try scheduleRepository.deleteScheduleEntry(entry)
        
        entries = try scheduleRepository.getScheduleEntries(forUserId: testUser.id)
        XCTAssertEqual(entries.count, 0)
    }
    
    func testMultipleScheduleEntries() throws {
        let entries = [
            ScheduleEntry(userId: testUser.id, period: "Period 1", subject: "Math", room: "101", teacher: "Teacher 1"),
            ScheduleEntry(userId: testUser.id, period: "Period 2", subject: "Science", room: "102", teacher: "Teacher 2"),
            ScheduleEntry(userId: testUser.id, period: "Period 3", subject: "English", room: "103", teacher: "Teacher 3")
        ]
        
        for entry in entries {
            try scheduleRepository.createScheduleEntry(entry)
        }
        
        let fetchedEntries = try scheduleRepository.getScheduleEntries(forUserId: testUser.id)
        XCTAssertEqual(fetchedEntries.count, 3)
        
        // Verify they're sorted by period
        XCTAssertEqual(fetchedEntries[0].period, "Period 1")
        XCTAssertEqual(fetchedEntries[1].period, "Period 2")
        XCTAssertEqual(fetchedEntries[2].period, "Period 3")
    }
}
