//
//  EmailStaffViewModel.swift
//  PocketPad
//
//  ViewModel for email staff directory
//

import Foundation

@MainActor
class EmailStaffViewModel: ObservableObject {
    @Published var staffMembers: [StaffDirectoryEntry] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let repository = StaffDirectoryRepository.shared
    
    func loadStaff() async {
        isLoading = true
        errorMessage = nil
        
        do {
            staffMembers = try repository.getAllStaff()
        } catch {
            errorMessage = "Failed to load staff directory: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
