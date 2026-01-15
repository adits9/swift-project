//
//  SignUpViewModel.swift
//  PocketPad
//
//  ViewModel for sign up functionality
//

import Foundation

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    var isValid: Bool {
        !fullName.isEmpty &&
        !username.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty
    }
    
    func signUp(appState: AppState) async {
        guard isValid else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        // Validation
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            return
        }
        
        guard username.count >= 3 else {
            errorMessage = "Username must be at least 3 characters"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Check if username already exists
            if let _ = try UserRepository.shared.getUser(byUsername: username) {
                errorMessage = "Username already taken"
                isLoading = false
                return
            }
            
            // Check if email already exists
            if let _ = try UserRepository.shared.getUser(byEmail: email) {
                errorMessage = "Email already registered"
                isLoading = false
                return
            }
            
            // Create user
            let user = try UserRepository.shared.createUser(
                username: username,
                email: email,
                password: password,
                fullName: fullName
            )
            
            // Auto-login after signup
            appState.login(user: user)
            
        } catch {
            errorMessage = "Sign up failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
