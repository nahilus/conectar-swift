//
//  UserProfileService.swift
//  Conectar
//
//  Created by Event on 9/11/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - User Profile Model
// This represents a user's complete profile data
struct UserProfile {
    let userId: String
    let email: String
    let displayName: String
    let description: String
    let skills: [String]
    let interests: [String]
    let profileCompleted: Bool
    let createdAt: Date
    let friends: [String]
    let friendRequests: [String]
    
    // Initialize from Firestore document
    init?(userId: String, data: [String: Any]) {
        self.userId = userId
        
        guard let email = data["email"] as? String else {
            return nil
        }
        
        self.email = email
        self.displayName = data["displayName"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        self.skills = data["skills"] as? [String] ?? []
        self.interests = data["interests"] as? [String] ?? []
        self.profileCompleted = data["profileCompleted"] as? Bool ?? false
        self.friends = data["friends"] as? [String] ?? []
        self.friendRequests = data["friendRequests"] as? [String] ?? []
        
        // Convert Firestore Timestamp to Date
        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
}

// MARK: - Profile Result
// Return type for profile operations
struct ProfileResult {
    let success: Bool
    let profile: UserProfile?
    let errorMessage: String?
}

// MARK: - User Profile Service
// Handles fetching and managing user profile data
class UserProfileService {
    
    static let shared = UserProfileService()
    private init() {}
    
    private let db = Firestore.firestore()
    
    // MARK: - Get Current User Profile
    /// Fetches the profile of the currently signed-in user
    /// Uses AuthService to get the current user's ID
    /// - Returns: ProfileResult with user profile or error
    func getCurrentUserProfile() async -> ProfileResult {
        // Use AuthService instead of accessing Firebase Auth directly
        guard let userId = AuthService.shared.getCurrentUserId() else {
            return ProfileResult(
                success: false,
                profile: nil,
                errorMessage: "No user is signed in"
            )
        }
        
        return await getUserProfile(userId: userId)
    }
    
    // MARK: - Get User Profile by ID
    /// Fetches any user's profile by their user ID
    /// Useful for viewing other users' profiles
    /// - Parameter userId: The ID of the user to fetch
    /// - Returns: ProfileResult with user profile or error
    func getUserProfile(userId: String) async -> ProfileResult {
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            
            guard document.exists, let data = document.data() else {
                return ProfileResult(
                    success: false,
                    profile: nil,
                    errorMessage: "User profile not found"
                )
            }
            
            guard let profile = UserProfile(userId: userId, data: data) else {
                return ProfileResult(
                    success: false,
                    profile: nil,
                    errorMessage: "Failed to parse user profile"
                )
            }
            
            return ProfileResult(
                success: true,
                profile: profile,
                errorMessage: nil
            )
            
        } catch {
            return ProfileResult(
                success: false,
                profile: nil,
                errorMessage: error.localizedDescription
            )
        }
    }
    
    // MARK: - Update Profile Description
    /// Updates just the description field
    /// - Parameter description: New description text
    /// - Returns: ProfileResult with updated profile or error
    func updateDescription(description: String) async -> ProfileResult {
        // Use AuthService to get current user
        guard let userId = AuthService.shared.getCurrentUserId() else {
            return ProfileResult(
                success: false,
                profile: nil,
                errorMessage: "No user is signed in"
            )
        }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "description": description,
                "updatedAt": Timestamp(date: Date())
            ])
            
            // Fetch and return updated profile
            return await getCurrentUserProfile()
            
        } catch {
            return ProfileResult(
                success: false,
                profile: nil,
                errorMessage: error.localizedDescription
            )
        }
    }
    
    // MARK: - Update Skills
    /// Updates the skills array
    /// - Parameter skills: New array of skills
    /// - Returns: ProfileResult with updated profile or error
    func updateSkills(skills: [String]) async -> ProfileResult {
        // Use AuthService to get current user
        guard let userId = AuthService.shared.getCurrentUserId() else {
            return ProfileResult(
                success: false,
                profile: nil,
                errorMessage: "No user is signed in"
            )
        }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "skills": skills,
                "updatedAt": Timestamp(date: Date())
            ])
            
            return await getCurrentUserProfile()
            
        } catch {
            return ProfileResult(
                success: false,
                profile: nil,
                errorMessage: error.localizedDescription
            )
        }
    }
    
    // MARK: - Update Interests
    /// Updates the interests array
    /// - Parameter interests: New array of interests
    /// - Returns: ProfileResult with updated profile or error
    func updateInterests(interests: [String]) async -> ProfileResult {
        // Use AuthService to get current user
        guard let userId = AuthService.shared.getCurrentUserId() else {
            return ProfileResult(
                success: false,
                profile: nil,
                errorMessage: "No user is signed in"
            )
        }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "interests": interests,
                "updatedAt": Timestamp(date: Date())
            ])
            
            return await getCurrentUserProfile()
            
        } catch {
            return ProfileResult(
                success: false,
                profile: nil,
                errorMessage: error.localizedDescription
            )
        }
    }
    
    // MARK: - Search Users
    /// Search for users by name (case-insensitive)
    /// - Parameter query: Search query string
    /// - Returns: Array of matching user profiles
    func searchUsers(query: String) async -> [UserProfile] {
        guard !query.isEmpty else { return [] }
        
        do {
            // Note: For better search, consider using a search service like Algolia
            // This is a simple implementation that fetches all users and filters
            let snapshot = try await db.collection("users")
                .whereField("profileCompleted", isEqualTo: true)
                .getDocuments()
            
            let profiles = snapshot.documents.compactMap { doc -> UserProfile? in
                UserProfile(userId: doc.documentID, data: doc.data())
            }
            
            // Filter by name (case-insensitive)
            let lowercaseQuery = query.lowercased()
            return profiles.filter { profile in
                profile.displayName.lowercased().contains(lowercaseQuery)
            }
            
        } catch {
            print("Error searching users: \(error.localizedDescription)")
            return []
        }
    }
}
