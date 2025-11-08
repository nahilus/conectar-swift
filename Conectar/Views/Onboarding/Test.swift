//  OnboardingStage1.swift
//  Conectar
//
//  Created by Event on 8/11/25.
//

import SwiftUI

// Cross-platform system colors for SwiftUI
extension Color {
    static var systemBackgroundCompat: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return Color(uiColor: .systemBackground)
        #elseif os(macOS)
        return Color(nsColor: .windowBackgroundColor)
        #else
        return Color(.sRGBLinear, red: 1, green: 1, blue: 1, opacity: 1)
        #endif
    }
    static var secondarySystemBackgroundCompat: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return Color(uiColor: .secondarySystemBackground)
        #elseif os(macOS)
        return Color(nsColor: .underPageBackgroundColor)
        #else
        return Color(.sRGBLinear, red: 0.95, green: 0.95, blue: 0.95, opacity: 1)
        #endif
    }
}

struct Test: View {
    // MARK: - State
    @State private var fullName: String = ""
    @State private var bio: String = ""
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) private var dismiss
    
    enum Field: Hashable { case name, bio }
    enum Route: Hashable { case stage2 }
    
    @State private var navigateToStage2: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient similar to the screenshot
                LinearGradient(colors: [Color.systemBackgroundCompat, Color.systemBackgroundCompat.opacity(0.7)], startPoint: .top, endPoint: .bottom)
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
            .navigationDestination(isPresented: $navigateToStage2) {
                // TODO: Replace with your real Stage 2 view when available
                OnboardingStage2Placeholder(fullName: fullName, bio: bio)
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    // MARK: - Header
    private var header: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: 48, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    Image(systemName: "sparkles")
                        .foregroundStyle(.white)
                        .font(.system(size: 22, weight: .semibold))
                }
                Text("Conectar")
                    .font(.system(size: 28, weight: .semibold))
                Spacer()
            }

            Text("Connect with like-minded collaborators and bring your ideas to life")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    // MARK: - Progress
    private var progress: some View {
        HStack(spacing: 8) {
            Capsule().fill(Color.primary).frame(height: 6).opacity(0.9)
            Capsule().fill(Color.primary.opacity(0.2)).frame(height: 6)
            Capsule().fill(Color.primary.opacity(0.2)).frame(height: 6)
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Form Card
    private var formCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Name section
            VStack(alignment: .leading, spacing: 6) {
                Text("What's your name?")
                    .font(.title3).fontWeight(.semibold)
                Text("This is how other collaborators will see you")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.secondarySystemBackgroundCompat)
                .overlay(
                    TextField("Alex Chen", text: $fullName)
                        .autocorrectionDisabled()
                        .modifier(AutocapWordsCompat())
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .focused($focusedField, equals: Field.name)
                )
                .frame(height: 48)

            // Bio section
            VStack(alignment: .leading, spacing: 6) {
                Text("Tell us about yourself")
                    .font(.title3).fontWeight(.semibold)
                Text("A brief bio helps others understand your background and goals")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.secondarySystemBackgroundCompat)
                    .frame(minHeight: 120)

                TextEditor(text: $bio)
                    .padding(12)
                    .focused($focusedField, equals: Field.bio)
                    .background(Color.clear)

                if bio.isEmpty {
                    Text("e.g., Full-stack developer passionate about AI and sustainable tech…")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                }
            }

            Button(action: continueTapped) {
                HStack {
                    Spacer()
                    Text("Continue").fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                    Spacer()
                }
                .padding(.vertical, 14)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill((fullName.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.black))
                )
            }
            .buttonStyle(.plain)
            .disabled(fullName.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.systemBackgroundCompat)
                .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
        )
    }

    private struct AutocapWordsCompat: ViewModifier {
        func body(content: Content) -> some View {
            #if os(iOS) || os(tvOS) || os(watchOS)
            if #available(iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
                return AnyView(content.textInputAutocapitalization(.words))
            } else {
                return AnyView(content.autocapitalization(.words))
            }
            #else
            return AnyView(content)
            #endif
        }
    }

    // MARK: - Actions
    private func continueTapped() {
        // Dismiss keyboard if needed and navigate to Stage 2
        focusedField = nil
        navigateToStage2 = true
    }
}

struct OnboardingStage2Placeholder: View {
    var fullName: String
    var bio: String
    var body: some View {
        VStack(spacing: 16) {
            Text("Onboarding – Stage 2")
                .font(.title.bold())
            Text("Welcome, \(fullName)")
            if !bio.isEmpty {
                Text("Bio: \(bio)").foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.systemBackgroundCompat)
    }
}

#Preview {
    Test()
}
