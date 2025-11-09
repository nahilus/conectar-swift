// FILE: RecommendationViewModel.swift

import Foundation
import Combine

class RecommendationViewModel: ObservableObject {
    @Published var currentUser: User
    @Published var allUsers: [User]
    @Published var recommendations: [UserMatch] = []
    @Published var isLoading = false
    private let engine = RecommendationEngine()

    init(currentUser: User, allUsers: [User]) {
        self.currentUser = currentUser
        self.allUsers = allUsers
    }

    func loadRecommendations() {
        isLoading = true
        // Simulate async processing
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let matches = self.engine.findMatches(for: self.currentUser, from: self.allUsers, limit: 20)
            DispatchQueue.main.async {
                self.recommendations = matches
                self.isLoading = false
            }
        }
    }
}
