// FILE: DataMapper.swift

import Foundation
import CoreLocation

/// A utility to map data from the mock source to the app's internal models.
struct DataMapper {

    /// Reads the raw mock data and transforms it into an array of `User` objects
    /// suitable for the recommendation engine.
    static func mapMockDataToUsers() -> [User] {
        var users: [User] = []

        for personLocation in MockUserData.otherPeopleLocations {
            let userId = personLocation.userId
            
            if let userProfile = MockUserData.getProfile(for: userId) {
                
                // [MODIFIED] The 'User' model is now created with the 'userId' property.
                let mappedUser = User(
                    id: UUID(),
                    userId: userProfile.userId, // [+ADD] Pass the original string ID from the UserProfile.
                    name: userProfile.displayName,
                    bio: userProfile.description,
                    interests: userProfile.interests,
                    skills: userProfile.skills,
                    projectIdeas: [], // Default empty array as UserProfile has no project ideas.
                    profileImage: nil,
                    coordinate: personLocation.coordinate
                )
                users.append(mappedUser)
            }
        }
        return users
    }
}
