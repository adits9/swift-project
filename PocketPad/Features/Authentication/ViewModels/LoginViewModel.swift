//
//  LoginViewModel.swift
//  PocketPad
//
//  ViewModel for login functionality
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    var isValid: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func login(appState: AppState) async {
        guard isValid else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Attempt authentication
            if let user = try UserRepository.shared.authenticate(username: username, password: password) {
                appState.login(user: user)
            } else {
                errorMessage = "Invalid username or password"
            }
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
