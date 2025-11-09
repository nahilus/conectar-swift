import SwiftUI
import MapKit
import CoreLocation

class RecommendationEngine {
    private let interestWeight: Double = 0.4
    private let skillWeight: Double = 0.35
    private let projectWeight: Double = 0.25

    func findMatches(for currentUser: User, from allUsers: [User], limit: Int = 10) -> [UserMatch] {
        let otherUsers = allUsers.filter { $0.id != currentUser.id }
        let matches = otherUsers.map { otherUser in
            let details = calculateMatchDetails(currentUser: currentUser, otherUser: otherUser)
            let score = calculateOverallScore(details: details)
            return UserMatch(user: otherUser, score: score, matchDetails: details)
        }
        return matches
            .sorted { $0.score > $1.score }
            .prefix(limit)
            .map { $0 }
    }

    private func calculateMatchDetails(currentUser: User, otherUser: User) -> MatchDetails {
        let commonInterests = Set(currentUser.interests.map { $0.lowercased() })
            .intersection(Set(otherUser.interests.map { $0.lowercased() }))
        let interestScore = calculateSimilarity(set1: currentUser.interests, set2: otherUser.interests)
        let commonSkills = Set(currentUser.skills.map { $0.lowercased() })
            .intersection(Set(otherUser.skills.map { $0.lowercased() }))
        let skillScore = calculateSimilarity(set1: currentUser.skills, set2: otherUser.skills)
        let projectScore = calculateProjectSimilarity(projects1: currentUser.projectIdeas, projects2: otherUser.projectIdeas)
        let commonThemes = findCommonProjectThemes(projects1: currentUser.projectIdeas, projects2: otherUser.projectIdeas)
        return MatchDetails(commonInterests: Array(commonInterests), commonSkills: Array(commonSkills), commonProjectThemes: commonThemes, interestScore: interestScore, skillScore: skillScore, projectScore: projectScore)
    }

    private func calculateSimilarity(set1: [String], set2: [String]) -> Double {
        let s1 = Set(set1.map { $0.lowercased() })
        let s2 = Set(set2.map { $0.lowercased() })
        guard !s1.isEmpty || !s2.isEmpty else { return 0 }
        let intersection = s1.intersection(s2).count
        let union = s1.union(s2).count
        return Double(intersection) / Double(union)
    }

    private func calculateProjectSimilarity(projects1: [String], projects2: [String]) -> Double {
        let keywords1 = extractKeywords(from: projects1)
        let keywords2 = extractKeywords(from: projects2)
        return calculateSimilarity(set1: keywords1, set2: keywords2)
    }

    private func extractKeywords(from projects: [String]) -> [String] {
        let stopWords = Set(["a", "an", "the", "and", "or", "but", "in", "on", "at", "to", "for", "of", "with", "is", "are", "was", "were"])
        return projects.flatMap { project in
            project.lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { $0.count > 2 && !stopWords.contains($0) }
        }
    }

    private func findCommonProjectThemes(projects1: [String], projects2: [String]) -> [String] {
        let keywords1 = Set(extractKeywords(from: projects1))
        let keywords2 = Set(extractKeywords(from: projects2))
        return Array(keywords1.intersection(keywords2).prefix(5))
    }

    private func calculateOverallScore(details: MatchDetails) -> Double {
        return (details.interestScore * interestWeight) +
               (details.skillScore * skillWeight) +
               (details.projectScore * projectWeight)
    }
}
