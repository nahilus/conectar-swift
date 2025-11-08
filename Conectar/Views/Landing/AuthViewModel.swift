import SwiftUI
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill all fields."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let success = try await APIService.shared.login(email: email, password: password)
            if success {
                isAuthenticated = true
            } else {
                errorMessage = "Invalid credentials."
            }
        } catch {
            errorMessage = error.localizedDescription
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
            let success = try await APIService.shared.register(email: email, password: password)
            if success {
                isAuthenticated = true
            } else {
                errorMessage = "Registration failed."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
