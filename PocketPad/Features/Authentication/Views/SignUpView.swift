//
//  SignUpView.swift
//  PocketPad
//
//  Sign up screen
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter your full name", text: $viewModel.fullName)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                        .accessibilityLabel("Full Name")
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Choose a username", text: $viewModel.username)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityLabel("Username")
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter your email", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .accessibilityLabel("Email")
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    SecureField("Choose a password", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityLabel("Password")
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm Password")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    SecureField("Re-enter password", text: $viewModel.confirmPassword)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityLabel("Confirm Password")
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action: {
                    Task {
                        await viewModel.signUp(appState: appState)
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(viewModel.isLoading || !viewModel.isValid)
                
                Spacer()
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AppState())
}
