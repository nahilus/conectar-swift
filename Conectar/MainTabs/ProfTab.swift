//
//  ProfTab.swift
//  Conectar
//
//  Created by Beautiful princess ❤️
//

import SwiftUI

struct ProfTab: View {
    @Binding var selectedTab: String
    @State private var selectedProfileTab: ProfileTabSection = .skills

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

            // Bottom navigation (make sure BottomNavBar exists elsewhere)
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
                        .fill(LinearGradient(colors: [Color.purple.opacity(0.9), Color.blue],
                                             startPoint: .topLeading,
                                             endPoint: .bottomTrailing))
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
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
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
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.06))
        )
    }
}

// MARK: - Segmented Tabs
enum ProfileTabSection: String, CaseIterable {
    case skills = "Skills"
    case projects = "Projects"
    case connections = "Connections"
}

struct SegmentedTabs: View {
    @Binding var selected: ProfileTabSection
    var body: some View {
        Picker("Select Profile Tab", selection: $selected) {
            ForEach(ProfileTabSection.allCases, id: \.self) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }
}

// MARK: - Content Card
struct ContentCard: View {
    let selected: ProfileTabSection
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            switch selected {
            case .skills:
                SectionBlock(title: "Skills") {
                    TagCloud(tags: ["React", "Node.js", "Python", "Swift", "Machine Learning", "Firebase", "REST APIs"])
                }
                SectionBlock(title: "Interests") {
                    TagCloud(tags: ["AI", "Sustainability", "Open Source", "Mobile Apps", "Design Systems"])
                }
            case .projects:
                Placeholder(text: "Projects will appear here")
            case .connections:
                Placeholder(text: "Connections will appear here")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.06))
        )
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

// MARK: - Tag Cloud (Improved layout, no UIScreen.main warning)
struct TagCloud: View {
    let tags: [String]
    let spacing: CGFloat = 8
    let lineSpacing: CGFloat = 8
    @Environment(\.displayScale) private var scale
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Environment(\.horizontalSizeClass) private var hSizeClass

    var body: some View {
        GeometryReader { geo in
            FlexibleView2(
                availableWidth: geo.size.width - 32, // account for horizontal padding
                data: tags,
                spacing: spacing,
                alignment: .leading
            ) { tag in
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
        .frame(height: idealHeight)
    }

    /// Fallback approximate height so the GeometryReader doesn't collapse
    private var idealHeight: CGFloat { 100 }
}


// MARK: - Flexible layout for wrapping tags (Fixed)
struct FlexibleView2<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    @State private var elementsSize: [Data.Element: CGSize] = [:]

    var body: some View {
        let rows = computeRows()
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { item in
                        content(item)
                            .fixedSize()
                            .background(SizeReader(size: binding(for: item)))
                    }
                }
            }
        }
    }

    private func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentWidth: CGFloat = 0

        for item in data {
            let itemSize = elementsSize[item, default: CGSize(width: availableWidth, height: 1)]
            let itemWidth = itemSize.width
            if currentWidth + itemWidth + spacing > availableWidth {
                currentWidth = 0
                rows.append([item])
            } else {
                rows[rows.count - 1].append(item)
            }
            currentWidth += itemWidth + spacing
        }
        return rows
    }

    private func binding(for key: Data.Element) -> Binding<CGSize> {
        Binding(
            get: { elementsSize[key, default: .zero] },
            set: { elementsSize[key] = $0 }
        )
    }
}

// MARK: - Helper to measure size of each tag
private struct SizeReader: View {
    @Binding var size: CGSize

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
        .onPreferenceChange(SizePreferenceKey.self) { newSize in
            size = newSize
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
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
