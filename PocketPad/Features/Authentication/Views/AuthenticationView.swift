//
//  AuthenticationView.swift
//  PocketPad
//
//  Main authentication screen with login/signup tabs
//

import SwiftUI

struct AuthenticationView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "book.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("PocketPad")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(Config.schoolName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                // Tab Picker
                Picker("", selection: $selectedTab) {
                    Text("Login").tag(0)
                    Text("Sign Up").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
                
                // Content
                TabView(selection: $selectedTab) {
                    LoginView()
                        .tag(0)
                    
                    SignUpView()
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AppState())
}
