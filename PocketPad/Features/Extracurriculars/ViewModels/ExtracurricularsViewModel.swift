//
//  ExtracurricularsViewModel.swift
//  PocketPad
//
//  ViewModel for extracurriculars
//

import Foundation

@MainActor
class ExtracurricularsViewModel: ObservableObject {
    @Published var allActivities: [Extracurricular] = []
    @Published var favoriteActivities: [Extracurricular] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let repository = ExtracurricularRepository.shared
    private var userId: String?
    private var favoriteIds: Set<String> = []
    
    func loadActivities(userId: String) async {
        self.userId = userId
        isLoading = true
        errorMessage = nil
        
        do {
            allActivities = try repository.getAllExtracurriculars()
            favoriteActivities = try repository.getFavorites(forUserId: userId)
            favoriteIds = Set(favoriteActivities.map { $0.id })
        } catch {
            errorMessage = "Failed to load activities: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func toggleFavorite(_ activityId: String) async {
        guard let userId = userId else { return }
        
        do {
            if favoriteIds.contains(activityId) {
                try repository.removeFavorite(userId: userId, extracurricularId: activityId)
                favoriteIds.remove(activityId)
            } else {
                try repository.addFavorite(userId: userId, extracurricularId: activityId)
                favoriteIds.insert(activityId)
            }
            
            // Reload favorites
            favoriteActivities = try repository.getFavorites(forUserId: userId)
        } catch {
            errorMessage = "Failed to update favorite: \(error.localizedDescription)"
        }
    }
    
    func isFavorite(_ activityId: String) -> Bool {
        favoriteIds.contains(activityId)
    }
}
