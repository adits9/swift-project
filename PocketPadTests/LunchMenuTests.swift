//
//  LunchMenuTests.swift
//  PocketPadTests
//
//  Unit tests for lunch menu functionality
//

import XCTest
@testable import PocketPad

final class LunchMenuTests: XCTestCase {
    var repository: LunchMenuRepository!
    
    override func setUpWithError() throws {
        DatabaseManager.shared.setupDatabase()
        repository = LunchMenuRepository.shared
    }
    
    override func tearDownWithError() throws {
        repository = nil
    }
    
    func testGetMenuItemForDate() throws {
        // Create a test menu item
        let calendar = Calendar.current
        let testDate = calendar.startOfDay(for: Date())
        
        let menuItem = LunchMenuItem(
            date: testDate,
            mainDish: "Test Pizza",
            sides: ["Salad", "Fruit"],
            dessert: "Cookie",
            vegetarianOption: "Veggie Pizza"
        )
        
        try repository.saveMenuItem(menuItem)
        
        // Retrieve it
        let retrieved = try repository.getMenuItem(for: testDate)
        
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.mainDish, "Test Pizza")
        XCTAssertEqual(retrieved?.sides.count, 2)
        XCTAssertEqual(retrieved?.dessert, "Cookie")
    }
    
    func testGetMenuItemForNonExistentDate() throws {
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .year, value: 10, to: Date())!
        
        let retrieved = try repository.getMenuItem(for: futureDate)
        XCTAssertNil(retrieved)
    }
    
    func testDateMatching() throws {
        let calendar = Calendar.current
        let testDate = calendar.date(from: DateComponents(year: 2026, month: 1, day: 15))!
        
        let menuItem = LunchMenuItem(
            date: testDate,
            mainDish: "Test Meal",
            sides: ["Side 1"],
            dessert: nil,
            vegetarianOption: nil
        )
        
        try repository.saveMenuItem(menuItem)
        
        // Test that we can retrieve with same date
        let sameDay = calendar.date(from: DateComponents(year: 2026, month: 1, day: 15, hour: 15))!
        let retrieved = try repository.getMenuItem(for: sameDay)
        
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.mainDish, "Test Meal")
    }
}
