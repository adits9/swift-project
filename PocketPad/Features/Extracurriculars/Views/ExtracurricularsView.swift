//
//  ExtracurricularsView.swift
//  PocketPad
//
//  View for extracurricular activities
//

import SwiftUI

struct ExtracurricularsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = ExtracurricularsViewModel()
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    
    var filteredActivities: [Extracurricular] {
        let activities = showFavoritesOnly ? viewModel.favoriteActivities : viewModel.allActivities
        
        if searchText.isEmpty {
            return activities
        } else {
            return activities.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter toggle
            Picker("Filter", selection: $showFavoritesOnly) {
                Text("All").tag(false)
                Text("Favorites").tag(true)
            }
            .pickerStyle(.segmented)
            .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if filteredActivities.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: showFavoritesOnly ? "star.slash" : "magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text(showFavoritesOnly ? "No favorites yet" : "No activities found")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    if !searchText.isEmpty {
                        Text("Try a different search")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            } else {
                List {
                    ForEach(filteredActivities) { activity in
                        ExtracurricularRow(
                            activity: activity,
                            isFavorite: viewModel.isFavorite(activity.id),
                            onFavoriteToggle: {
                                Task {
                                    await viewModel.toggleFavorite(activity.id)
                                }
                            }
                        )
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Extracurriculars")
        .searchable(text: $searchText, prompt: "Search activities")
        .task {
            if let userId = appState.currentUser?.id {
                await viewModel.loadActivities(userId: userId)
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

struct ExtracurricularRow: View {
    let activity: Extracurricular
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.name)
                        .font(.headline)
                    
                    Text(activity.category)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(categoryColor(for: activity.category))
                        .cornerRadius(4)
                }
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }
            
            // Details (collapsible)
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text(activity.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Label(activity.meetingTime, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label(activity.location, systemImage: "mappin.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label(activity.contactEmail, systemImage: "envelope")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .transition(.opacity)
            }
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(isExpanded ? "Show Less" : "Show More")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
    
    private func categoryColor(for category: String) -> Color {
        switch category {
        case "STEM": return .blue
        case "Arts": return .purple
        case "Sports": return .green
        case "Academic": return .orange
        case "Service": return .pink
        default: return .gray
        }
    }
}

#Preview {
    NavigationStack {
        ExtracurricularsView()
            .environmentObject(AppState())
    }
}
