//
//  Extensions.swift
//  PocketPad
//
//  Useful extensions
//

import Foundation
import GRDB

// MARK: - Array Extensions for GRDB JSON encoding

extension Array: DatabaseValueConvertible where Element == String {
    public var databaseValue: DatabaseValue {
        if let jsonData = try? JSONEncoder().encode(self),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString.databaseValue
        }
        return DatabaseValue.null
    }
    
    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> [String]? {
        guard let jsonString = String.fromDatabaseValue(dbValue),
              let jsonData = jsonString.data(using: .utf8),
              let array = try? JSONDecoder().decode([String].self, from: jsonData) else {
            return nil
        }
        return array
    }
}

// MARK: - Date Extensions

extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay())!
    }
}

// MARK: - String Extensions

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
