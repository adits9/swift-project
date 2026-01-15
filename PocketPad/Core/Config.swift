//
//  Config.swift
//  PocketPad
//
//  Centralized configuration
//

import Foundation

struct Config {
    // School Information
    static let schoolName = "Jefferson High School"
    static let schoolCalendarURL = "https://example.com/school-calendar"
    
    // Social Media Links
    static let socialLinks: [SocialLink] = [
        SocialLink(platform: "Instagram", url: "https://instagram.com/jeffersonhigh", icon: "instagram"),
        SocialLink(platform: "Twitter", url: "https://twitter.com/jeffersonhigh", icon: "twitter"),
        SocialLink(platform: "YouTube", url: "https://youtube.com/@jeffersonhigh", icon: "youtube"),
        SocialLink(platform: "Facebook", url: "https://facebook.com/jeffersonhigh", icon: "facebook")
    ]
    
    // Schedule Configuration
    static let schedulePeriods = ["Period 1", "Period 2", "Period 3", "Period 4", "Period 5", "Period 6", "Period 7"]
    
    // Database Configuration
    static let databaseName = "PocketPad.db"
}

struct SocialLink: Identifiable {
    let id = UUID()
    let platform: String
    let url: String
    let icon: String
}
