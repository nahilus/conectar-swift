//
//  OnboardingStage1.swift
//  Conectar
//

import SwiftUI

struct OnboardingStage1: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable { case name, bio }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(.systemBackground), Color(.systemBackground).opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    header
                    progress
                    formCard
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                logo
                Text("Conectar")
                    .font(.system(size: 28, weight: .semibold))
                Spacer()
            }
            Text("Connect with like-minded collaborators and bring your ideas to life")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var progress: some View {
        HStack(spacing: 8) {
            Capsule().fill(Color.primary).frame(height: 6).opacity(0.9)
            Capsule().fill(Color.primary.opacity(0.2)).frame(height: 6)
            Capsule().fill(Color.primary.opacity(0.2)).frame(height: 6)
        }
    }
    
    private var formCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What's your name?")
                .font(.title3).fontWeight(.semibold)
            TextField("Alex Chen", text: $viewModel.fullName)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .name)
            
            Text("Tell us about yourself")
                .font(.title3).fontWeight(.semibold)
            TextEditor(text: $viewModel.bio)
                .frame(minHeight: 100)
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .focused($focusedField, equals: .bio)
            
            Button {
                focusedField = nil
                viewModel.goNext()
            } label: {
                HStack {
                    Spacer()
                    Text("Continue")
                    Image(systemName: "arrow.right")
                    Spacer()
                }
                .padding()
                .foregroundStyle(.white)
                .background(RoundedRectangle(cornerRadius: 14).fill(viewModel.fullName.isEmpty ? .gray : .black))
            }
            .disabled(viewModel.fullName.isEmpty)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color(.systemBackground)))
        .shadow(radius: 8)
    }
    
    private var logo: some View {
        ZStack {
            LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Image(systemName: "sparkles")
                .foregroundStyle(.white)
                .font(.system(size: 22, weight: .semibold))
        }
    }
}


