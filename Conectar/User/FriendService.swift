//
//  FriendService.swift
//  Conectar
//
//  Created by Event on 9/11/25.
// Not tested yet

import Foundation
import FirebaseFirestore

// MARK: - Friend Request Model
struct FriendRequest {
    let requestId: String
    let fromUserId: String
    let fromUserName: String
    let toUserId: String
    let status: RequestStatus
    let createdAt: Date
    
    enum RequestStatus: String {
        case pending = "pending"
        case accepted = "accepted"
        case declined = "declined"
    }
    
    init?(requestId: String, data: [String: Any]) {
        self.requestId = requestId
        
        guard let fromUserId = data["fromUserId"] as? String,
              let fromUserName = data["fromUserName"] as? String,
              let toUserId = data["toUserId"] as? String,
              let statusString = data["status"] as? String,
              let status = RequestStatus(rawValue: statusString) else {
            return nil
        }
        
        self.fromUserId = fromUserId
        self.fromUserName = fromUserName
        self.toUserId = toUserId
        self.status = status
        
        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
}

// MARK: - Friend Result Types
struct FriendResult {
    let success: Bool
    let message: String?
}

struct FriendListResult {
    let success: Bool
    let friends: [UserProfile]
    let errorMessage: String?
}

struct FriendRequestListResult {
    let success: Bool
    let requests: [FriendRequest]
    let errorMessage: String?
}

// MARK: - Friend Service
class FriendService {
    
    static let shared = FriendService()
    private init() {}
    
    private let db = Firestore.firestore()
    
    // MARK: - Send Friend Request
    /// Sends a friend request to another user
    /// - Parameter toUserId: The ID of the user to send request to
    /// - Returns: FriendResult with success status and message
    func sendFriendRequest(toUserId: String) async -> FriendResult {
        guard let currentUserId = AuthService.shared.getCurrentUserId() else {
            return FriendResult(success: false, message: "You must be signed in to send friend requests")
        }
        
        // Can't send request to yourself
        guard currentUserId != toUserId else {
            return FriendResult(success: false, message: "You cannot send a friend request to yourself")
        }
        
        do {
            // Check if already friends
            let currentUserDoc = try await db.collection("users").document(currentUserId).getDocument()
            if let friends = currentUserDoc.data()?["friends"] as? [String],
               friends.contains(toUserId) {
                return FriendResult(success: false, message: "You are already friends with this user")
            }
            
            // Check if request already exists
            let existingRequests = try await db.collection("friendRequests")
                .whereField("fromUserId", isEqualTo: currentUserId)
                .whereField("toUserId", isEqualTo: toUserId)
                .whereField("status", isEqualTo: "pending")
                .getDocuments()
            
            if !existingRequests.isEmpty {
                return FriendResult(success: false, message: "Friend request already sent")
            }
            
            // Get current user's name
            let currentUserProfile = await UserProfileService.shared.getCurrentUserProfile()
            let currentUserName = currentUserProfile.profile?.displayName ?? "Unknown User"
            
            // Create friend request document
            let requestData: [String: Any] = [
                "fromUserId": currentUserId,
                "fromUserName": currentUserName,
                "toUserId": toUserId,
                "status": "pending",
                "createdAt": Timestamp(date: Date())
            ]
            
            let requestRef = try await db.collection("friendRequests").addDocument(data: requestData)
            
            // Add request ID to recipient's friendRequests array
            try await db.collection("users").document(toUserId).updateData([
                "friendRequests": FieldValue.arrayUnion([requestRef.documentID])
            ])
            
            return FriendResult(success: true, message: "Friend request sent successfully")
            
        } catch {
            return FriendResult(success: false, message: error.localizedDescription)
        }
    }
    
    // MARK: - Accept Friend Request
    /// Accepts a pending friend request
    /// - Parameter requestId: The ID of the friend request to accept
    /// - Returns: FriendResult with success status and message
    func acceptFriendRequest(requestId: String) async -> FriendResult {
        guard let currentUserId = AuthService.shared.getCurrentUserId() else {
            return FriendResult(success: false, message: "You must be signed in")
        }
        
        do {
            // Get the request
            let requestDoc = try await db.collection("friendRequests").document(requestId).getDocument()
            guard let requestData = requestDoc.data(),
                  let request = FriendRequest(requestId: requestId, data: requestData) else {
                return FriendResult(success: false, message: "Friend request not found")
            }
            
            // Verify this request is for the current user
            guard request.toUserId == currentUserId else {
                return FriendResult(success: false, message: "This request is not for you")
            }
            
            // Update request status to accepted
            try await db.collection("friendRequests").document(requestId).updateData([
                "status": "accepted",
                "acceptedAt": Timestamp(date: Date())
            ])
            
            // Add each user to the other's friends list
            try await db.collection("users").document(currentUserId).updateData([
                "friends": FieldValue.arrayUnion([request.fromUserId]),
                "friendRequests": FieldValue.arrayRemove([requestId])
            ])
            
            try await db.collection("users").document(request.fromUserId).updateData([
                "friends": FieldValue.arrayUnion([currentUserId])
            ])
            
            return FriendResult(success: true, message: "Friend request accepted")
            
        } catch {
            return FriendResult(success: false, message: error.localizedDescription)
        }
    }
    
    // MARK: - Decline Friend Request
    /// Declines a pending friend request
    /// - Parameter requestId: The ID of the friend request to decline
    /// - Returns: FriendResult with success status and message
    func declineFriendRequest(requestId: String) async -> FriendResult {
        guard let currentUserId = AuthService.shared.getCurrentUserId() else {
            return FriendResult(success: false, message: "You must be signed in")
        }
        
        do {
            // Get the request
            let requestDoc = try await db.collection("friendRequests").document(requestId).getDocument()
            guard let requestData = requestDoc.data(),
                  let request = FriendRequest(requestId: requestId, data: requestData) else {
                return FriendResult(success: false, message: "Friend request not found")
            }
            
            // Verify this request is for the current user
            guard request.toUserId == currentUserId else {
                return FriendResult(success: false, message: "This request is not for you")
            }
            
            // Update request status to declined
            try await db.collection("friendRequests").document(requestId).updateData([
                "status": "declined",
                "declinedAt": Timestamp(date: Date())
            ])
            
            // Remove from current user's friendRequests array
            try await db.collection("users").document(currentUserId).updateData([
                "friendRequests": FieldValue.arrayRemove([requestId])
            ])
            
            return FriendResult(success: true, message: "Friend request declined")
            
        } catch {
            return FriendResult(success: false, message: error.localizedDescription)
        }
    }
    
    // MARK: - Get Pending Friend Requests
    /// Gets all pending friend requests for the current user
    /// - Returns: FriendRequestListResult with list of pending requests
    func getPendingFriendRequests() async -> FriendRequestListResult {
        guard let currentUserId = AuthService.shared.getCurrentUserId() else {
            return FriendRequestListResult(success: false, requests: [], errorMessage: "You must be signed in")
        }
        
        do {
            // Get all pending requests where current user is the recipient
            let snapshot = try await db.collection("friendRequests")
                .whereField("toUserId", isEqualTo: currentUserId)
                .whereField("status", isEqualTo: "pending")
                .order(by: "createdAt", descending: true)
                .getDocuments()
            
            let requests = snapshot.documents.compactMap { doc -> FriendRequest? in
                FriendRequest(requestId: doc.documentID, data: doc.data())
            }
            
            return FriendRequestListResult(success: true, requests: requests, errorMessage: nil)
            
        } catch {
            return FriendRequestListResult(success: false, requests: [], errorMessage: error.localizedDescription)
        }
    }
    
    // MARK: - Get Friends List
    /// Gets all friends of the current user
    /// - Returns: FriendListResult with list of friend profiles
    func getFriendsList() async -> FriendListResult {
        guard let currentUserId = AuthService.shared.getCurrentUserId() else {
            return FriendListResult(success: false, friends: [], errorMessage: "You must be signed in")
        }
        
        do {
            // Get current user's document
            let userDoc = try await db.collection("users").document(currentUserId).getDocument()
            guard let friendIds = userDoc.data()?["friends"] as? [String] else {
                return FriendListResult(success: true, friends: [], errorMessage: nil)
            }
            
            // If no friends, return empty list
            if friendIds.isEmpty {
                return FriendListResult(success: true, friends: [], errorMessage: nil)
            }
            
            // Fetch all friend profiles
            var friends: [UserProfile] = []
            for friendId in friendIds {
                let result = await UserProfileService.shared.getUserProfile(userId: friendId)
                if let profile = result.profile {
                    friends.append(profile)
                }
            }
            
            return FriendListResult(success: true, friends: friends, errorMessage: nil)
            
        } catch {
            return FriendListResult(success: false, friends: [], errorMessage: error.localizedDescription)
        }
    }
    
    // MARK: - Remove Friend (Unfriend)
    /// Removes a friend from your friends list
    /// - Parameter friendUserId: The ID of the friend to remove
    /// - Returns: FriendResult with success status and message
    func removeFriend(friendUserId: String) async -> FriendResult {
        guard let currentUserId = AuthService.shared.getCurrentUserId() else {
            return FriendResult(success: false, message: "You must be signed in")
        }
        
        do {
            // Remove from both users' friends lists
            try await db.collection("users").document(currentUserId).updateData([
                "friends": FieldValue.arrayRemove([friendUserId])
            ])
            
            try await db.collection("users").document(friendUserId).updateData([
                "friends": FieldValue.arrayRemove([currentUserId])
            ])
            
            return FriendResult(success: true, message: "Friend removed successfully")
            
        } catch {
            return FriendResult(success: false, message: error.localizedDescription)
        }
    }
    
    // MARK: - Check Friendship Status
    /// Checks if two users are friends
    /// - Parameter userId: The ID of the user to check
    /// - Returns: True if friends, false otherwise
    func areFriends(userId: String) async -> Bool {
        guard let currentUserId = AuthService.shared.getCurrentUserId() else {
            return false
        }
        
        do {
            let userDoc = try await db.collection("users").document(currentUserId).getDocument()
            if let friends = userDoc.data()?["friends"] as? [String] {
                return friends.contains(userId)
            }
            return false
        } catch {
            return false
        }
    }
}
