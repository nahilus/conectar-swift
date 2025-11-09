import Foundation
import CoreLocation

// MARK: - Mock User Profiles Data
struct MockUserData {
    static let profiles: [String: UserProfile] = [
        "alice_001": UserProfile(
            userId: "alice_001",
            data: [
                "email": "alice@example.com",
                "displayName": "Alice Chen",
                "description": "iOS developer passionate about creating beautiful apps",
                "skills": ["Swift", "iOS Development", "UI/UX Design", "Figma"],
                "interests": ["Photography", "Hiking", "Coffee", "Tech Meetups"],
                "profileCompleted": true,
                "friends": [],
                "friendRequests": []
            ]
        )!,
        
        "bob_002": UserProfile(
            userId: "bob_002",
            data: [
                "email": "bob@example.com",
                "displayName": "Bob Martinez",
                "description": "ML engineer exploring the future of AI",
                "skills": ["Python", "Machine Learning", "Data Science", "TensorFlow"],
                "interests": ["AI", "Gaming", "Music Production", "Basketball"],
                "profileCompleted": true,
                "friends": ["grace_007"], // Bob is friends with Grace
                "friendRequests": []
            ]
        )!,
        
        "charlie_003": UserProfile(
            userId: "charlie_003",
            data: [
                "email": "charlie@example.com",
                "displayName": "Charlie Wong",
                "description": "Full-stack developer and blockchain enthusiast",
                "skills": ["JavaScript", "React", "Node.js", "GraphQL", "TypeScript"],
                "interests": ["Web3", "Cycling", "Cooking", "Travel"],
                "profileCompleted": true,
                "friends": [],
                "friendRequests": []
            ]
        )!,
        
        "david_004": UserProfile(
            userId: "david_004",
            data: [
                "email": "david@example.com",
                "displayName": "David Kim",
                "description": "Backend engineer building scalable systems",
                "skills": ["Java", "Spring Boot", "Microservices", "Docker", "Kubernetes"],
                "interests": ["Reading", "Chess", "Running", "Startups"],
                "profileCompleted": true,
                "friends": [],
                "friendRequests": []
            ]
        )!,
        
        "eve_005": UserProfile(
            userId: "eve_005",
            data: [
                "email": "eve@example.com",
                "displayName": "Eve Thompson",
                "description": "Product designer focused on human-centered design",
                "skills": ["Product Design", "User Research", "Prototyping", "Sketch"],
                "interests": ["Art", "Yoga", "Sustainability", "Volunteering"],
                "profileCompleted": true,
                "friends": [],
                "friendRequests": []
            ]
        )!,
        
        "frank_006": UserProfile(
            userId: "frank_006",
            data: [
                "email": "frank@example.com",
                "displayName": "Frank Rodriguez",
                "description": "Mobile developer who loves to explore new places",
                "skills": ["React Native", "Flutter", "Mobile Design", "Firebase"],
                "interests": ["Skateboarding", "Street Art", "Music Festivals", "Food Tours"],
                "profileCompleted": true,
                "friends": [],
                "friendRequests": []
            ]
        )!,
        
        "grace_007": UserProfile(
            userId: "grace_007",
            data: [
                "email": "grace@example.com",
                "displayName": "Grace Lee",
                "description": "DevOps engineer passionate about automation",
                "skills": ["DevOps", "AWS", "CI/CD", "Terraform", "Monitoring"],
                "interests": ["Rock Climbing", "Meditation", "Podcasts", "Gardening"],
                "profileCompleted": true,
                "friends": ["bob_002"], // Grace is friends with Bob
                "friendRequests": []
            ]
        )!,
        
        "heidi_008": UserProfile(
            userId: "heidi_008",
            data: [
                "email": "heidi@example.com",
                "displayName": "Heidi Patel",
                "description": "Data analyst turning numbers into insights",
                "skills": ["Data Analytics", "SQL", "Tableau", "Excel", "Power BI"],
                "interests": ["Dancing", "Language Learning", "Baking", "Board Games"],
                "profileCompleted": true,
                "friends": [],
                "friendRequests": []
            ]
        )!,
        
        "ivan_009": UserProfile(
            userId: "ivan_009",
            data: [
                "email": "ivan@example.com",
                "displayName": "Ivan Volkov",
                "description": "Game developer creating immersive experiences",
                "skills": ["C++", "Game Development", "Unity", "3D Modeling", "Blender"],
                "interests": ["Video Games", "Anime", "VR", "Sci-Fi Movies"],
                "profileCompleted": true,
                "friends": [],
                "friendRequests": []
            ]
        )!,
        
        "judy_010": UserProfile(
            userId: "judy_010",
            data: [
                "email": "judy@example.com",
                "displayName": "Judy Anderson",
                "description": "Content creator with a passion for storytelling",
                "skills": ["Content Writing", "SEO", "Social Media", "Copywriting"],
                "interests": ["Writing", "Fashion", "Theater", "Wine Tasting"],
                "profileCompleted": true,
                "friends": [],
                "friendRequests": []
            ]
        )!
    ]
    
    // Helper function to get profile by userId
    static func getProfile(for userId: String) -> UserProfile? {
        return profiles[userId]
    }
    
    // Mock locations array with userIds
    static let otherPeopleLocations: [(name: String, userId: String, coordinate: CLLocationCoordinate2D)] = [
        ("Alice", "alice_001", CLLocationCoordinate2D(latitude: 37.7845, longitude: -122.4090)),
        ("Bob", "bob_002", CLLocationCoordinate2D(latitude: 37.7840, longitude: -122.4125)),
        ("Charlie", "charlie_003", CLLocationCoordinate2D(latitude: 37.7810, longitude: -122.4095)),
        ("David", "david_004", CLLocationCoordinate2D(latitude: 37.7805, longitude: -122.4120)),
        ("Eve", "eve_005", CLLocationCoordinate2D(latitude: 37.7827, longitude: -122.4103)),
        ("Frank", "frank_006", CLLocationCoordinate2D(latitude: 37.7888, longitude: -122.4060)),
        ("Grace", "grace_007", CLLocationCoordinate2D(latitude: 37.7895, longitude: -122.4055)),
        ("Heidi", "heidi_008", CLLocationCoordinate2D(latitude: 37.7901, longitude: -122.4058)),
        ("Ivan", "ivan_009", CLLocationCoordinate2D(latitude: 37.7872, longitude: -122.4070)),
        ("Judy", "judy_010", CLLocationCoordinate2D(latitude: 37.7862, longitude: -122.4050))
    ]
}

// MARK: - Mock UserProfileService Extension
extension UserProfileService {
    /// Get mock profile for testing/development
    /// This mimics the real getUserProfile function but returns mock data
    func getMockProfile(userId: String) async -> ProfileResult {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Find profile by userId
        if let profile = MockUserData.profiles[userId] {
            return ProfileResult(
                success: true,
                profile: profile,
                errorMessage: nil
            )
        } else {
            return ProfileResult(
                success: false,
                profile: nil,
                errorMessage: "Profile not found"
            )
        }
    }
}

// MARK: - Mock FriendService Extension
extension FriendService {
    /// Check if users are friends (mock version)
    func getMockFriendStatus(userId: String) async -> Bool {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        // Check if the userId is in the friends list
        // Bob (bob_002) and Grace (grace_007) are mutual friends
        return ["bob_002", "grace_007"].contains(userId)
    }
    
    /// Send friend request (mock version)
    func sendMockFriendRequest(toUserId: String) async -> (success: Bool, message: String?) {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        return (success: true, message: "Friend request sent successfully!")
    }
}
