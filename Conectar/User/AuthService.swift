import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - Result Types
// These are the return types your frontend will receive

struct AuthResult {
    let success: Bool
    let userId: String?
    let email: String?
    let errorMessage: String?
}

// MARK: - Auth Service
// This handles all authentication operations

class AuthService {
    
    // Singleton pattern - only one instance exists
    static let shared = AuthService()
    private init() {}
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    // MARK: - Sign Up Function
    /// Creates a new user account with email and password only
    /// Profile setup (name, description, skills, interests) comes later
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password (min 6 characters for Firebase)
    /// - Returns: AuthResult with success status and user info or error
    func signUp(email: String, password: String) async -> AuthResult {
        
        // Input validation
        guard !email.isEmpty else {
            return AuthResult(success: false, userId: nil, email: nil, errorMessage: "Email cannot be empty")
        }
        
        guard !password.isEmpty else {
            return AuthResult(success: false, userId: nil, email: nil, errorMessage: "Password cannot be empty")
        }
        
        guard password.count >= 6 else {
            return AuthResult(success: false, userId: nil, email: nil, errorMessage: "Password must be at least 6 characters")
        }
        
        do {
            // Create user in Firebase Authentication
            let authResult = try await auth.createUser(withEmail: email, password: password)
            let user = authResult.user
            
            // Create basic user document in Firestore (profile setup comes later)
            try await createUserDocument(userId: user.uid, email: email)
            
            return AuthResult(
                success: true,
                userId: user.uid,
                email: user.email,
                errorMessage: nil
            )
            
        } catch let error as NSError {
            // Handle Firebase-specific errors
            let errorMessage = handleAuthError(error)
            return AuthResult(success: false, userId: nil, email: nil, errorMessage: errorMessage)
        }
    }
    
    // MARK: - Sign In Function
    /// Signs in an existing user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: AuthResult with success status and user info or error
    func signIn(email: String, password: String) async -> AuthResult {
        
        // Input validation
        guard !email.isEmpty else {
            return AuthResult(success: false, userId: nil, email: nil, errorMessage: "Email cannot be empty")
        }
        
        guard !password.isEmpty else {
            return AuthResult(success: false, userId: nil, email: nil, errorMessage: "Password cannot be empty")
        }
        
        do {
            // Sign in with Firebase Authentication
            let authResult = try await auth.signIn(withEmail: email, password: password)
            let user = authResult.user
            
            return AuthResult(
                success: true,
                userId: user.uid,
                email: user.email,
                errorMessage: nil
            )
            
        } catch let error as NSError {
            // Handle Firebase-specific errors
            let errorMessage = handleAuthError(error)
            return AuthResult(success: false, userId: nil, email: nil, errorMessage: errorMessage)
        }
    }
    
    // MARK: - Sign Out Function
    /// Signs out the current user
    /// - Returns: AuthResult with success status or error
    func signOut() -> AuthResult {
        do {
            try auth.signOut()
            return AuthResult(success: true, userId: nil, email: nil, errorMessage: nil)
        } catch let error {
            return AuthResult(success: false, userId: nil, email: nil, errorMessage: error.localizedDescription)
        }
    }
    
    // MARK: - Get Current User
    /// Returns the currently signed-in user's ID
    /// - Returns: User ID if signed in, nil otherwise
    func getCurrentUserId() -> String? {
        return auth.currentUser?.uid
    }
    
    /// Returns the currently signed-in user's email
    /// - Returns: Email if signed in, nil otherwise
    func getCurrentUserEmail() -> String? {
        return auth.currentUser?.email
    }
    
    /// Checks if a user is currently signed in
    /// - Returns: true if user is signed in, false otherwise
    func isUserSignedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    // MARK: - Update User Profile
    /// Updates user profile with name, description, skills, and interests
    /// Call this after sign up to complete the profile setup
    /// - Parameters:
    ///   - name: User's display name
    ///   - description: User's bio/description
    ///   - skills: Array of user's skills
    ///   - interests: Array of user's interests
    /// - Returns: AuthResult with success status or error
    func updateUserProfile(name: String, description: String, skills: [String], interests: [String]) async -> AuthResult {
        
        guard let userId = getCurrentUserId() else {
            return AuthResult(success: false, userId: nil, email: nil, errorMessage: "No user is signed in")
        }
        
        // Validate input
        guard !name.isEmpty else {
            return AuthResult(success: false, userId: userId, email: nil, errorMessage: "Name cannot be empty")
        }
        
        do {
            // Update Firebase Auth display name
            if let currentUser = auth.currentUser {
                let changeRequest = currentUser.createProfileChangeRequest()
                changeRequest.displayName = name
                try await changeRequest.commitChanges()
            }
            
            // Update Firestore user document
            let userData: [String: Any] = [
                "displayName": name,
                "description": description,
                "skills": skills,
                "interests": interests,
                "profileCompleted": true,
                "updatedAt": Timestamp(date: Date())
            ]
            
            try await db.collection("users").document(userId).updateData(userData)
            
            return AuthResult(
                success: true,
                userId: userId,
                email: getCurrentUserEmail(),
                errorMessage: nil
            )
            
        } catch let error {
            return AuthResult(success: false, userId: userId, email: nil, errorMessage: error.localizedDescription)
        }
    }
    
    // MARK: - Private Helper Functions
    
    /// Creates a basic user document in Firestore with minimal data
    /// Profile details (name, description, skills, interests) are added later via updateUserProfile
    private func createUserDocument(userId: String, email: String) async throws {
        let userData: [String: Any] = [
            "email": email,
            "createdAt": Timestamp(date: Date()),
            "profileCompleted": false, // Flag to track if user completed profile setup
            "friends": [], // Empty array for friends list
            "friendRequests": [] // Empty array for pending requests
        ]
        
        try await db.collection("users").document(userId).setData(userData)
    }
    
    /// Converts Firebase Auth errors to user-friendly messages
    private func handleAuthError(_ error: NSError) -> String {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return "An unknown error occurred"
        }
        
        switch errorCode {
        case .emailAlreadyInUse:
            return "This email is already registered"
        case .invalidEmail:
            return "Invalid email address"
        case .weakPassword:
            return "Password is too weak"
        case .userNotFound:
            return "No account found with this email"
        case .wrongPassword:
            return "Incorrect password"
        case .networkError:
            return "Network error. Please check your connection"
        case .tooManyRequests:
            return "Too many attempts. Please try again later"
        default:
            return error.localizedDescription
        }
    }
}
