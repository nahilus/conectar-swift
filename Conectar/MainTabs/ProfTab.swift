//
//  ProfTab.swift
//  Conectar
//
//  Created by Beautiful princess ❤️
//

import SwiftUI

struct ProfTab: View {
    @Binding var selectedTab: String
    @State private var selectedProfileTab: ProfileTab = .skills

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HeaderCard()
                    ActionButtons()
                    StatsRow()
                    SegmentedTabs(selected: $selectedProfileTab)
                    ContentCard(selected: selectedProfileTab)
                        .padding(.bottom, 60) // Leave space for bottom nav
                }
                .padding(.horizontal)
                .padding(.top, 12)
            }

            // Consistent bottom navigation (same as MapTab)
            BottomNavBar(selectedTab: $selectedTab)
                .padding(.horizontal)
                .padding(.bottom, 8)
                .background(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    ProfTab(selectedTab: .constant("Profile"))
}

// MARK: - Header
struct HeaderCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color.purple.opacity(0.9), Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 64, height: 64)
                    Image(systemName: "person.fill")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Alex Chen")
                        .font(.title3).bold()
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("San Francisco, CA")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Button {
                    // settings tapped
                } label: {
                    Image(systemName: "gearshape")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .padding(10)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }

            Text("Full-stack developer passionate about AI and sustainable tech.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color(.secondarySystemBackground)))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06))
        )
    }
}

// MARK: - Action Buttons
struct ActionButtons: View {
    var body: some View {
        HStack(spacing: 12) {
            CapsuleButton(title: "Edit Profile", systemImage: "square.and.pencil", style: .outline)
            CapsuleButton(title: "Contact", systemImage: "paperplane", style: .outline)
        }
    }
}

struct CapsuleButton: View {
    enum Style { case filled, outline }
    let title: String
    let systemImage: String
    var style: Style = .filled

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                Text(title)
            }
            .font(.subheadline.weight(.semibold))
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .background(
            Group {
                switch style {
                case .filled:
                    Capsule().fill(Color.accentColor)
                case .outline:
                    Capsule().strokeBorder(Color.primary.opacity(0.2))
                }
            }
        )
        .foregroundStyle(style == .filled ? .white : .primary)
    }
}

// MARK: - Stats
struct StatsRow: View {
    var body: some View {
        HStack(spacing: 12) {
            StatCard(value: "8", label: "Projects")
            StatCard(value: "24", label: "Connections")
            StatCard(value: "156", label: "Contributions")
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title3).bold()
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color(.secondarySystemBackground)))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.06)))
    }
}

// MARK: - Segmented Tabs
enum ProfileTab: String, CaseIterable {
    case skills = "Skills"
    case projects = "Projects"
    case connections = "Connections"
}

struct SegmentedTabs: View {
    @Binding var selected: ProfileTab
    var body: some View {
        Picker("", selection: $selected) {
            ForEach(ProfileTab.allCases, id: \.self) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }
}

// MARK: - Content Card
struct ContentCard: View {
    let selected: ProfileTab
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            switch selected {
            case .skills:
                SectionBlock(title: "Skills") {
                    TagCloud(tags: ["React", "Node.js", "Python", "Machine Learning"])
                }
                SectionBlock(title: "Interests") {
                    TagCloud(tags: ["AI", "Sustainability", "Open Source", "Mobile Apps"])
                }
            case .projects:
                Placeholder(text: "Projects will appear here")
            case .connections:
                Placeholder(text: "Connections will appear here")
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color(.systemBackground)))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.06)))
    }
}

// MARK: - Section Block
struct SectionBlock<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            content
        }
    }
}
// MARK: - Tag Cloud (using FlowLayout)
struct TagCloud: View {
    let tags: [String]
    let spacing: CGFloat = 8
    let lineSpacing: CGFloat = 8
    
    var body: some View {
        FlowLayout(spacing: spacing, lineSpacing: lineSpacing) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.footnote.weight(.medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.08))
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
// MARK: - FlowLayout (View-based implementation, compatible with iOS 15+)
struct FlowLayout<Content: View>: View {
    let spacing: CGFloat
    let lineSpacing: CGFloat
    let content: () -> Content

    init(
        spacing: CGFloat = 8,
        lineSpacing: CGFloat = 8,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            content()
                .alignmentGuide(.leading) { d in
                    if (abs(width - d.width) > geometry.size.width) {
                        width = 0
                        height -= d.height + lineSpacing
                    }
                    let result = width
                    if d.width <= geometry.size.width {
                        width -= d.width + spacing
                    }
                    return result
                }
                .alignmentGuide(.top) { _ in
                    let result = height
                    if width == 0 {
                        height -= lineSpacing
                    }
                    return result
                }
        }
    }
}

// MARK: - Placeholder
struct Placeholder: View {
    let text: String
    var body: some View {
        HStack(spacing: 10) {
            ProgressView()
            Text(text)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}
