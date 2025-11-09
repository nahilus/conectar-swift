import SwiftUI
import FirebaseAuth
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    init() {
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
        }
    }

    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill all fields."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("User logged in: \(result.user.uid)")
            isAuthenticated = true
        } catch {
            errorMessage = mapFirebaseError(error)
        }
    }

    func register() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill all fields."
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("User registered: \(result.user.uid)")
            isAuthenticated = true
        } catch {
            errorMessage = mapFirebaseError(error)
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func mapFirebaseError(_ error: Error) -> String {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email address."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Email is already in use."
        case AuthErrorCode.weakPassword.rawValue:
            return "Password should be at least 6 characters."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Incorrect password."
        case AuthErrorCode.userNotFound.rawValue:
            return "No account found for this email."
        default:
            return error.localizedDescription
        }
    }
}
