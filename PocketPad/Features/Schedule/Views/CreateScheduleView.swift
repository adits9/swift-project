//
//  CreateScheduleView.swift
//  PocketPad
//
//  Create new schedule entry
//

import SwiftUI

struct CreateScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: ScheduleViewModel
    
    @State private var selectedPeriod = Config.schedulePeriods[0]
    @State private var subject = ""
    @State private var room = ""
    @State private var teacher = ""
    @State private var dayType = "Regular"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Class Information") {
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(Config.schedulePeriods, id: \.self) { period in
                            Text(period).tag(period)
                        }
                    }
                    
                    TextField("Subject", text: $subject)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Room Number", text: $room)
                        .textInputAutocapitalization(.characters)
                    
                    TextField("Teacher Name", text: $teacher)
                        .textInputAutocapitalization(.words)
                }
                
                Section("Schedule Type") {
                    Picker("Day Type", selection: $dayType) {
                        Text("Regular").tag("Regular")
                        Text("A Day").tag("A")
                        Text("B Day").tag("B")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Add Class")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveEntry()
                        }
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !subject.isEmpty && !room.isEmpty && !teacher.isEmpty
    }
    
    private func saveEntry() async {
        guard let userId = appState.currentUser?.id else { return }
        
        let entry = ScheduleEntry(
            userId: userId,
            period: selectedPeriod,
            subject: subject,
            room: room,
            teacher: teacher,
            dayType: dayType
        )
        
        await viewModel.addEntry(entry)
        dismiss()
    }
}

#Preview {
    CreateScheduleView(viewModel: ScheduleViewModel())
        .environmentObject(AppState())
}
