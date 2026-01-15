//
//  AppState.swift
//  PocketPad
//
//  App-wide state management
//

import Foundation

class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    
    func login(user: User) {
        self.currentUser = user
        self.isAuthenticated = true
        UserDefaults.standard.set(user.id, forKey: "currentUserId")
    }
    
    func logout() {
        self.currentUser = nil
        self.isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "currentUserId")
    }
    
    func restoreSession() {
        if let userId = UserDefaults.standard.string(forKey: "currentUserId") {
            // Try to load user from database
            if let user = try? UserRepository.shared.getUser(byId: userId) {
                self.currentUser = user
                self.isAuthenticated = true
            }
        }
    }
}
