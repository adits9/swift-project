//
//  LunchMenuItem.swift
//  PocketPad
//
//  Lunch menu item data model
//

import Foundation
import GRDB

struct LunchMenuItem: Codable, Identifiable {
    var id: String
    var date: Date
    var mainDish: String
    var sides: [String]
    var dessert: String?
    var vegetarianOption: String?
    
    init(id: String = UUID().uuidString,
         date: Date,
         mainDish: String,
         sides: [String],
         dessert: String? = nil,
         vegetarianOption: String? = nil) {
        self.id = id
        self.date = date
        self.mainDish = mainDish
        self.sides = sides
        self.dessert = dessert
        self.vegetarianOption = vegetarianOption
    }
}

// MARK: - GRDB Conformance
extension LunchMenuItem: FetchableRecord, PersistableRecord {
    static let databaseTableName = "lunch_menu_items"
    
    static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace
    )
}
