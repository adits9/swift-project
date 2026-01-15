//
//  PocketPadApp.swift
//  PocketPad
//
//  Created on 2026-01-15.
//

import SwiftUI

@main
struct PocketPadApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        // Initialize database on app launch
        DatabaseManager.shared.setupDatabase()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
