//
//  profile.swift
//  Conectar
//
//  Created by Event on 8/11/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// Cross-platform color helpers (file-local)
fileprivate extension Color {
    static var sysGray6: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemGray6)
        #else
        return Color.gray.opacity(0.12)
        #endif
    }
    static var sysBackground: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemBackground)
        #else
        return Color.white
        #endif
    }
}

// Profile screen implementation
// Make the model Codable so it can be decoded from Firebase JSON
struct UserProfile: Codable, Equatable {
    var name: String
    var location: String?
    var bio: String?
    var projects: Int?
    var connections: Int?
    var contributions: Int?
    var skills: [String]?
    var interests: [String]?

    // Convenience computed properties returning safe defaults
    var displayLocation: String { location ?? "" }
    var displayBio: String { bio ?? "" }
    var displayProjects: Int { projects ?? 0 }
    var displayConnections: Int { connections ?? 0 }
    var displayContributions: Int { contributions ?? 0 }
    var displaySkills: [String] { skills ?? [] }
    var displayInterests: [String] { interests ?? [] }

    static var sample: UserProfile {
        UserProfile(name: "Alex Chen", location: "San Francisco, CA", bio: "Full-stack developer passionate about AI and sustainable tech", projects: 8, connections: 24, contributions: 156, skills: ["React", "Node.js", "Python", "Machine Learning"], interests: ["AI", "Sustainability", "Open Source", "Mobile Apps"])
    }
}

struct ProfileView: View {
    @State private var selectedTab: Int = 0
    @State private var user: UserProfile = UserProfile.sample
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                headerCard
                debugBanner

                statsCard

                tabSelector

                contentCard

                Spacer(minLength: 40)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.bottom, 40) // prevent overlap with tab bar
            .background(Color.sysBackground)
        }
        // Add a bottom safe area inset so content isn't hidden behind a tab bar
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 48)
        }
        .navigationTitle("Profile")
        .onAppear(perform: loadProfile)
        .overlay {
            if isLoading {
                ProgressView()
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }

    private func loadProfile() {
        isLoading = true
        errorMessage = nil

        // Ensure Firebase base URL is configured
        guard FirebaseService.shared.isConfigured else {
            // Not configured: show sample and guide the developer
            self.user = .sample
            self.errorMessage = "FirebaseDatabaseURL not set in Info.plist. Add key 'FirebaseDatabaseURL' with your RTDB URL to load real data. Showing sample data."
            self.isLoading = false
            return
        }

        // Read profile id from Info.plist; if missing show sample fallback and a hint
        guard let profileId = Bundle.main.object(forInfoDictionaryKey: "FirebaseProfileID") as? String, !profileId.isEmpty else {
            self.user = .sample
            self.errorMessage = "FirebaseProfileID not set in Info.plist. Add key 'FirebaseProfileID' with the user id to fetch. Showing sample data."
            self.isLoading = false
            return
        }

        Task {
            do {
                let profile = try await FirebaseService.shared.fetchProfile(userId: profileId)
                DispatchQueue.main.async {
                    self.user = profile
                    self.isLoading = false
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.user = .sample
                    self.isLoading = false
                    self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
                }
            }
        }
    }

    // Header with avatar, name, location, bio, actions
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 64, height: 64)
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white.opacity(0.9))
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(user.name)
                            .font(.title2)
                            .bold()
                        Spacer()
                        Button(action: {
                            // settings action
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.primary)
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
                        }
                    }

                    HStack(spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.gray)
                        Text(user.displayLocation)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
            }

            Text(user.displayBio)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {
                Button(action: {
                    // edit profile
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit Profile")
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
                }

                Button(action: {
                    // contact action
                }) {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Contact")
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.sysBackground).shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2))
    }

    private var statsCard: some View {
        VStack(spacing: 0) {
            HStack {
                statItem(number: user.displayProjects, title: "Projects")
                Divider().frame(height: 44)
                statItem(number: user.displayConnections, title: "Connections")
                Divider().frame(height: 44)
                statItem(number: user.displayContributions, title: "Contributions")
            }
            .padding(.vertical, 16)
        }
        .padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.sysBackground).shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2))
    }

    private func statItem(number: Int, title: String) -> some View {
        VStack(spacing: 6) {
            Text("\(number)")
                .font(.title3)
                .bold()
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    private var tabSelector: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { idx in
                let title = ["Skills", "Projects", "Connections"][idx]
                Button(action: { selectedTab = idx }) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(selectedTab == idx ? .black : .gray)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(selectedTab == idx ? Color.sysGray6 : Color.clear)
                        .cornerRadius(12)
                }
            }
        }
        .padding(6)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.sysGray6.opacity(0.4)))
        .padding(.horizontal, 2)
    }

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            if selectedTab == 0 {
                Text("Skills").font(.headline)
                FlowLayout(items: user.displaySkills, content: { label in
                    Chip(text: label, filled: true)
                })

                Divider().padding(.vertical, 6)

                Text("Interests").font(.headline)
                FlowLayout(items: user.displayInterests, content: { label in
                    Chip(text: label, filled: false)
                })
            } else if selectedTab == 1 {
                Text("Projects").font(.headline)
                Text("No projects yet — add one to showcase your work.")
                    .foregroundColor(.gray)
                    .padding(.top, 6)
            } else {
                Text("Connections").font(.headline)
                Text("\(user.displayConnections) connections")
                    .foregroundColor(.gray)
                    .padding(.top, 6)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.sysBackground).shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2))
    }

    private var debugBanner: some View {
        VStack(alignment: .leading, spacing: 6) {
            if FirebaseService.shared.isConfigured {
                HStack(spacing: 8) {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .foregroundColor(.blue)
                    Text("Using Firebase: \(FirebaseService.shared.configuredURLString ?? "")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(action: { loadProfile() }) {
                        Text("Retry")
                    }
                    .font(.caption)
                }
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)
                    Text("Using sample data — set 'FirebaseDatabaseURL' & 'FirebaseProfileID' in Info.plist to load real data")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(action: { loadProfile() }) {
                        Text("Retry")
                    }
                    .font(.caption)
                }
            }
        }
        .padding(.horizontal, 6)
    }
}

// Simple chip view
struct Chip: View {
    let text: String
    var filled: Bool = false

    var body: some View {
        Text(text)
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(filled ? Color.sysGray6 : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.25), lineWidth: filled ? 0 : 1)
            )
            .cornerRadius(12)
    }
}

// Very small flow layout for chips
struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element == String {
    let items: Data
    let spacing: CGFloat
    let content: (String) -> Content

    init(items: Data, spacing: CGFloat = 8, @ViewBuilder content: @escaping (String) -> Content) {
        self.items = items
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        _FlowLayoutInner(items: Array(items), spacing: spacing, content: content)
    }
}

// Inner view holds state (measured width) and does the layout
private struct _FlowLayoutInner<Content: View>: View {
    let items: [String]
    let spacing: CGFloat
    let content: (String) -> Content

    @State private var containerWidth: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            // Measurer: capture width of the parent container without affecting layout
            GeometryReader { proxy in
                Color.clear
                    .preference(key: _WidthPreferenceKey.self, value: proxy.size.width)
            }
            .frame(height: 0)

            // Layout rows based on measured width
            let rows = computeRows(maxWidth: max(10, containerWidth - 32))
            ForEach(0..<rows.count, id: \ .self) { rowIndex in
                HStack(spacing: spacing) {
                    ForEach(rows[rowIndex], id: \ .self) { item in
                        content(item)
                    }
                }
            }
        }
        .onPreferenceChange(_WidthPreferenceKey.self) { value in
            // Avoid tiny changes causing layout churn
            if abs(value - containerWidth) > 0.5 {
                containerWidth = value
            }
        }
    }

    private func computeRows(maxWidth: CGFloat) -> [[String]] {
        #if canImport(UIKit)
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        #else
        let font: Any? = nil
        #endif

        var rows: [[String]] = [[]]
        var currentWidth: CGFloat = 0

        for item in items {
            let textWidth: CGFloat
            #if canImport(UIKit)
            let attributes = [NSAttributedString.Key.font: font as Any]
            textWidth = (item as NSString).size(withAttributes: attributes as? [NSAttributedString.Key: Any]).width
            #else
            textWidth = CGFloat(item.count) * 8.0
            #endif

            let chipWidth = textWidth + 24 // approximate horizontal padding (12 + 12)

            if rows.last!.isEmpty {
                rows[rows.count - 1].append(item)
                currentWidth = chipWidth
            } else if currentWidth + spacing + chipWidth <= maxWidth {
                rows[rows.count - 1].append(item)
                currentWidth += spacing + chipWidth
            } else {
                rows.append([item])
                currentWidth = chipWidth
            }
        }

        return rows
    }
}

private struct _WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

// MARK: - Previews
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
        .previewDevice("iPhone 14")
    }
}
