import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}

    func login(email: String, password: String) async throws -> Bool {
        // Simulate async API call
        try await Task.sleep(for: .seconds(1))
        return true // Replace with real network response
    }

    func register(email: String, password: String) async throws -> Bool {
        try await Task.sleep(for: .seconds(1))
        return true
    }
}
