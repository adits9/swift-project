//
//  ScheduleViewModel.swift
//  PocketPad
//
//  ViewModel for schedule management
//

import Foundation

@MainActor
class ScheduleViewModel: ObservableObject {
    @Published var scheduleEntries: [ScheduleEntry] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let repository = ScheduleRepository.shared
    
    func loadSchedule(userId: String, dayType: String = "Regular") async {
        isLoading = true
        errorMessage = nil
        
        do {
            scheduleEntries = try repository.getScheduleEntries(forUserId: userId, dayType: dayType)
        } catch {
            errorMessage = "Failed to load schedule: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func addEntry(_ entry: ScheduleEntry) async {
        do {
            try repository.createScheduleEntry(entry)
            await loadSchedule(userId: entry.userId, dayType: entry.dayType)
        } catch {
            errorMessage = "Failed to add entry: \(error.localizedDescription)"
        }
    }
    
    func updateEntry(_ entry: ScheduleEntry) async {
        do {
            try repository.updateScheduleEntry(entry)
            await loadSchedule(userId: entry.userId, dayType: entry.dayType)
        } catch {
            errorMessage = "Failed to update entry: \(error.localizedDescription)"
        }
    }
    
    func deleteEntry(_ entry: ScheduleEntry) async {
        do {
            try repository.deleteScheduleEntry(entry)
            await loadSchedule(userId: entry.userId, dayType: entry.dayType)
        } catch {
            errorMessage = "Failed to delete entry: \(error.localizedDescription)"
        }
    }
}
