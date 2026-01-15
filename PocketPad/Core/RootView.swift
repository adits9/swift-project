//
//  RootView.swift
//  PocketPad
//
//  Root navigation coordinator
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.isAuthenticated {
                DashboardView()
            } else {
                AuthenticationView()
            }
        }
        .onAppear {
            appState.restoreSession()
        }
    }
}
