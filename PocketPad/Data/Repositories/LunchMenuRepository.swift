//
//  LunchMenuRepository.swift
//  PocketPad
//
//  Repository for Lunch Menu operations
//

import Foundation
import GRDB

class LunchMenuRepository {
    static let shared = LunchMenuRepository()
    
    private var db: DatabaseQueue {
        DatabaseManager.shared.database
    }
    
    private init() {}
    
    // MARK: - Operations
    
    func loadMenuFromJSON() throws {
        guard let url = Bundle.main.url(forResource: "lunch_menu", withExtension: "json") else {
            print("⚠️ lunch_menu.json not found in bundle")
            return
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let menuItems = try decoder.decode([LunchMenuItem].self, from: data)
        
        try db.write { db in
            for item in menuItems {
                try item.save(db)
            }
        }
        
        print("✅ Loaded \(menuItems.count) lunch menu items")
    }
    
    func getMenuItem(for date: Date) throws -> LunchMenuItem? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return try db.read { db in
            try LunchMenuItem
                .filter(Column("date") >= startOfDay && Column("date") < endOfDay)
                .fetchOne(db)
        }
    }
    
    func getAllMenuItems() throws -> [LunchMenuItem] {
        try db.read { db in
            try LunchMenuItem.order(Column("date")).fetchAll(db)
        }
    }
    
    func saveMenuItem(_ item: LunchMenuItem) throws {
        try db.write { db in
            try item.save(db)
        }
    }
}
