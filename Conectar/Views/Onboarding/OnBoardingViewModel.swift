//
//  OnboardingViewModel.swift
//  Conectar
//
//  Created by ChatGPT on 8/11/25.
//

import Foundation
import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    // Shared state between all onboarding screens
    @Published var stage: Int = 1
    @Published var fullName: String = ""
    @Published var bio: String = ""
    @Published var skills: Set<String> = []
    @Published var interests: Set<String> = []
    
    // Example server endpoint (replace with your backend)
    private let apiURL = URL(string: "https://example.com/api/onboarding")!
    
    func goNext() {
        if stage < 3 {
            stage += 1
        }
    }
    
    func goBack() {
        if stage > 1 {
            stage -= 1
        }
    }
    
    func submit() async {
        // Convert all data to JSON for sending to a server
        let payload: [String: Any] = [
            "name": fullName,
            "bio": bio,
            "skills": Array(skills),
            "interests": Array(interests)
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else { return }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("Server response: \(httpResponse.statusCode)")
            }
            print("Response data:", String(data: data, encoding: .utf8) ?? "")
        } catch {
            print("Error sending onboarding data:", error.localizedDescription)
        }
    }
}
