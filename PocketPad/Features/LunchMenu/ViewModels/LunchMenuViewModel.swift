//
//  LunchMenuViewModel.swift
//  PocketPad
//
//  ViewModel for lunch menu
//

import Foundation

@MainActor
class LunchMenuViewModel: ObservableObject {
    @Published var currentMenu: LunchMenuItem?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let repository = LunchMenuRepository.shared
    private var hasLoadedFromJSON = false
    
    func loadMenu(for date: Date) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Load from JSON on first run
            if !hasLoadedFromJSON {
                try repository.loadMenuFromJSON()
                hasLoadedFromJSON = true
            }
            
            // Get menu for the selected date
            currentMenu = try repository.getMenuItem(for: date)
        } catch {
            errorMessage = "Failed to load menu: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
