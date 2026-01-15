//
//  ScheduleView.swift
//  PocketPad
//
//  Main schedule view with create/view options
//

import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var showingCreateSchedule = false
    
    var body: some View {
        ZStack {
            if viewModel.scheduleEntries.isEmpty {
                // Empty state
                VStack(spacing: 20) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("No Schedule Yet")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Create your class schedule to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        showingCreateSchedule = true
                    }) {
                        Label("Create Schedule", systemImage: "plus.circle.fill")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
            } else {
                // Schedule list
                List {
                    ForEach(viewModel.scheduleEntries) { entry in
                        ScheduleEntryRow(entry: entry, viewModel: viewModel)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("My Schedule")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingCreateSchedule = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateSchedule) {
            CreateScheduleView(viewModel: viewModel)
        }
        .task {
            if let userId = appState.currentUser?.id {
                await viewModel.loadSchedule(userId: userId)
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

struct ScheduleEntryRow: View {
    let entry: ScheduleEntry
    @ObservedObject var viewModel: ScheduleViewModel
    @State private var showingEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.period)
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Menu {
                    Button(action: {
                        showingEditSheet = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: {
                        Task {
                            await viewModel.deleteEntry(entry)
                        }
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.gray)
                }
            }
            
            Text(entry.subject)
                .font(.body)
                .fontWeight(.semibold)
            
            HStack {
                Label(entry.room, systemImage: "door.left.hand.open")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label(entry.teacher, systemImage: "person")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showingEditSheet) {
            EditScheduleView(entry: entry, viewModel: viewModel)
        }
    }
}

#Preview {
    NavigationStack {
        ScheduleView()
            .environmentObject(AppState())
    }
}
