//
//  OnboardingStage2.swift
//  Conectar
//

import SwiftUI

struct OnboardingStage2: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    private let skills: [String] = [
        "React", "Node.js", "Python",
        "Swift", "Kotlin",
        "Machine Learning", "Figma",
        "UI/UX Design", "Data Science",
        "DevOps", "Mobile Dev",
        "Backend"
    ]
    
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
            Capsule().fill(Color.gray.opacity(0.2)).frame(height: 6)
        }
    }
    
    private var formCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What are your skills?")
                .font(.title3).fontWeight(.semibold)
            Text("Select all that apply – this helps us match you with relevant projects")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 12) {
                ForEach(skills, id: \.self) { skill in
                    SkillChip(title: skill, isSelected: viewModel.skills.contains(skill)) {
                        toggle(skill)
                    }
                }
            }
            
            HStack(spacing: 16) {
                Button("Back") { viewModel.goBack() }
                    .buttonStyle(.bordered)
                Button("Continue") { viewModel.goNext() }
                    .disabled(viewModel.skills.isEmpty)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: 28).fill(Color(.systemBackground)))
        .shadow(radius: 8)
    }
    
    private func toggle(_ skill: String) {
        if viewModel.skills.contains(skill) {
            viewModel.skills.remove(skill)
        } else {
            viewModel.skills.insert(skill)
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
