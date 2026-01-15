//
//  EditScheduleView.swift
//  PocketPad
//
//  Edit existing schedule entry
//

import SwiftUI

struct EditScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    let entry: ScheduleEntry
    @ObservedObject var viewModel: ScheduleViewModel
    
    @State private var selectedPeriod: String
    @State private var subject: String
    @State private var room: String
    @State private var teacher: String
    @State private var dayType: String
    
    init(entry: ScheduleEntry, viewModel: ScheduleViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        _selectedPeriod = State(initialValue: entry.period)
        _subject = State(initialValue: entry.subject)
        _room = State(initialValue: entry.room)
        _teacher = State(initialValue: entry.teacher)
        _dayType = State(initialValue: entry.dayType)
    }
    
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
            .navigationTitle("Edit Class")
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
                            await updateEntry()
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
    
    private func updateEntry() async {
        var updatedEntry = entry
        updatedEntry.period = selectedPeriod
        updatedEntry.subject = subject
        updatedEntry.room = room
        updatedEntry.teacher = teacher
        updatedEntry.dayType = dayType
        
        await viewModel.updateEntry(updatedEntry)
        dismiss()
    }
}
