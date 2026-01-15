//
//  DashboardView.swift
//  PocketPad
//
//  Main dashboard after login
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDestination: DashboardDestination?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back,")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text(appState.currentUser?.fullName ?? "Student")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Dashboard Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        DashboardTile(
                            icon: "calendar",
                            title: "Schedule",
                            color: .blue,
                            destination: .schedule
                        )
                        
                        DashboardTile(
                            icon: "fork.knife",
                            title: "Lunch Menu",
                            color: .orange,
                            destination: .lunchMenu
                        )
                        
                        DashboardTile(
                            icon: "star.fill",
                            title: "Activities",
                            color: .purple,
                            destination: .extracurriculars
                        )
                        
                        DashboardTile(
                            icon: "envelope.fill",
                            title: "Email Staff",
                            color: .green,
                            destination: .email
                        )
                        
                        DashboardTile(
                            icon: "calendar.circle",
                            title: "Calendar",
                            color: .red,
                            destination: .calendar
                        )
                        
                        DashboardTile(
                            icon: "link",
                            title: "Social Links",
                            color: .cyan,
                            destination: .socialLinks
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
                .padding(.bottom)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationDestination(item: $selectedDestination) { destination in
                destinationView(for: destination)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            appState.logout()
                        }) {
                            Label("Logout", systemImage: "arrow.right.square")
                        }
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .navigationTitle("PocketPad")
        }
        .environment(\.selectedDestination, $selectedDestination)
    }
    
    @ViewBuilder
    private func destinationView(for destination: DashboardDestination) -> some View {
        switch destination {
        case .schedule:
            ScheduleView()
        case .lunchMenu:
            LunchMenuView()
        case .extracurriculars:
            ExtracurricularsView()
        case .email:
            EmailStaffView()
        case .calendar:
            CalendarView()
        case .socialLinks:
            SocialLinksView()
        }
    }
}

enum DashboardDestination: Hashable {
    case schedule
    case lunchMenu
    case extracurriculars
    case email
    case calendar
    case socialLinks
}

// Environment key for navigation
private struct SelectedDestinationKey: EnvironmentKey {
    static let defaultValue: Binding<DashboardDestination?> = .constant(nil)
}

extension EnvironmentValues {
    var selectedDestination: Binding<DashboardDestination?> {
        get { self[SelectedDestinationKey.self] }
        set { self[SelectedDestinationKey.self] = newValue }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState())
}
