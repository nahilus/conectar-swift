//
//  OnboardingStage3.swift
//  Conectar
//

import SwiftUI

struct OnboardingStage3: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    private let interests: [String] = [
        "AI", "Sustainability", "Open Source", "Mobile Apps",
        "Web3", "EdTech", "Healthcare", "FinTech",
        "Gaming", "Social Impact", "Research", "Startups"
    ]
    
    @State private var isSubmitting = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                progress
                formCard
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                logo
                Text("Conectar")
                    .font(.system(size: 28, weight: .bold))
                Spacer()
            }
            Text("Connect with like-minded collaborators and bring your ideas to life")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }
    
    private var progress: some View {
        HStack(spacing: 12) {
            Capsule().fill(Color.black).frame(height: 6)
            Capsule().fill(Color.black).frame(height: 6)
            Capsule().fill(Color.black).frame(height: 6)
        }
    }
    
    private var formCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What interests you?")
                .font(.title3).fontWeight(.semibold)
            Text("Choose topics you're passionate about to find the right collaborators")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 12) {
                ForEach(interests, id: \.self) { interest in
                    SkillChip(title: interest, isSelected: viewModel.interests.contains(interest)) {
                        toggle(interest)
                    }
                }
            }
            
            HStack(spacing: 16) {
                Button("Back") { viewModel.goBack() }
                    .buttonStyle(.bordered)
                Button {
                    Task {
                        isSubmitting = true
                        await viewModel.submit()
                        isSubmitting = false
                        print("✅ Onboarding Complete")
                    }
                } label: {
                    HStack {
                        Spacer()
                        if isSubmitting {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Get Started")
                            Image(systemName: "arrow.right")
                        }
                        Spacer()
                    }
                }
                .disabled(viewModel.interests.isEmpty || isSubmitting)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: 28).fill(Color(.systemBackground)))
        .shadow(radius: 8)
    }
    
    private func toggle(_ interest: String) {
        if viewModel.interests.contains(interest) {
            viewModel.interests.remove(interest)
        } else {
            viewModel.interests.insert(interest)
        }
    }
    
    private var logo: some View {
        ZStack {
            LinearGradient(colors: [Color.purple, Color.blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Image(systemName: "sparkles")
                .foregroundStyle(.white)
                .font(.system(size: 22, weight: .semibold))
        }
    }
}
