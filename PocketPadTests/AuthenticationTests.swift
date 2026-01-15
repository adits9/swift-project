//
//  AuthenticationTests.swift
//  PocketPadTests
//
//  Unit tests for authentication
//

import XCTest
@testable import PocketPad

final class AuthenticationTests: XCTestCase {
    var repository: UserRepository!
    
    override func setUpWithError() throws {
        repository = UserRepository.shared
        
        // Setup test database
        DatabaseManager.shared.setupDatabase()
    }
    
    override func tearDownWithError() throws {
        // Clean up test data
        repository = nil
    }
    
    func testUserCreation() throws {
        let username = "testuser_\(UUID().uuidString.prefix(8))"
        let email = "\(username)@test.com"
        
        let user = try repository.createUser(
            username: username,
            email: email,
            password: "password123",
            fullName: "Test User"
        )
        
        XCTAssertEqual(user.username, username)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.fullName, "Test User")
        XCTAssertFalse(user.passwordHash.isEmpty)
        
        // Cleanup
        try repository.deleteUser(user)
    }
    
    func testUserAuthentication() throws {
        let username = "authtest_\(UUID().uuidString.prefix(8))"
        let email = "\(username)@test.com"
        let password = "securepass123"
        
        // Create user
        let user = try repository.createUser(
            username: username,
            email: email,
            password: password,
            fullName: "Auth Test"
        )
        
        // Test successful authentication
        let authenticatedUser = try repository.authenticate(username: username, password: password)
        XCTAssertNotNil(authenticatedUser)
        XCTAssertEqual(authenticatedUser?.id, user.id)
        
        // Test failed authentication with wrong password
        let failedAuth = try repository.authenticate(username: username, password: "wrongpassword")
        XCTAssertNil(failedAuth)
        
        // Test failed authentication with non-existent user
        let noUser = try repository.authenticate(username: "nonexistent", password: password)
        XCTAssertNil(noUser)
        
        // Cleanup
        try repository.deleteUser(user)
    }
    
    func testDuplicateUsername() throws {
        let username = "duplicate_\(UUID().uuidString.prefix(8))"
        let email1 = "\(username)1@test.com"
        let email2 = "\(username)2@test.com"
        
        // Create first user
        let user1 = try repository.createUser(
            username: username,
            email: email1,
            password: "password123",
            fullName: "User One"
        )
        
        // Try to create second user with same username
        XCTAssertThrowsError(try repository.createUser(
            username: username,
            email: email2,
            password: "password456",
            fullName: "User Two"
        ))
        
        // Cleanup
        try repository.deleteUser(user1)
    }
}
