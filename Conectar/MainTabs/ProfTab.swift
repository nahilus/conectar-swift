import SwiftUI

struct ProfTab: View {
    @Binding var selectedTab: String
    @State private var selectedProfileTab: ProfileTab = .skills
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HeaderCard()
                    ActionButtons()
                    StatsRow()
                    SegmentedTabs(selected: $selectedProfileTab)
                    ContentCard(selected: selectedProfileTab)
                    Spacer(minLength: 80) // room for tab bar
                }
                .padding(.horizontal)
                .padding(.top, 12)
            }
            BottomTabBar(selectedTab: $selectedTab)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
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
            Text("Full-stack developer passionate about AI and sustainable tech")
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

// MARK: - Buttons
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
        Button {
            // action
        } label: {
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
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.clear))
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

struct TagCloud: View {
    let tags: [String]
    var body: some View {
        FlexibleHStack(spacing: 8, lineSpacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.footnote.weight(.medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.secondarySystemBackground)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08)))
            }
        }
    }
}

// MARK: - Flexible layout for tags
struct FlexibleHStack<Content: View>: View {
    let spacing: CGFloat
    let lineSpacing: CGFloat
    @ViewBuilder let content: Content
    
    init(spacing: CGFloat = 8, lineSpacing: CGFloat = 8, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.content = content()
    }
    
    var body: some View {
        _FlexibleHStack(spacing: spacing, lineSpacing: lineSpacing, content: content)
    }
}

private struct _FlexibleHStack<Content: View>: View {
    let spacing: CGFloat
    let lineSpacing: CGFloat
    let content: Content
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                content
                    .fixedSize()
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > geo.size.width {
                            width = 0
                            height -= d.height + lineSpacing
                        }
                        let result = width
                        if d.width <= geo.size.width { width -= d.width + spacing }
                        return result
                    })
                    .alignmentGuide(.top) { _ in height }
            }
        }
        .frame(minHeight: 0)
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

// MARK: - Bottom Tab Bar
struct BottomTabBar: View {
    @Binding var selectedTab: String
    
    var body: some View {
        HStack {
            ForEach(BottomItem.allCases, id: \.self) { item in
                VStack(spacing: 4) {
                    Image(systemName: item.icon)
                        .font(.body)
                    Text(item.title)
                        .font(.caption2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundStyle(selectedTab == item.rawValue.capitalized ? Color.accentColor : .secondary)
                .onTapGesture { selectedTab = item.rawValue.capitalized }
            }
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal)
        .padding(.bottom, 8)
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
    }
}

enum BottomItem: String, CaseIterable {
    case discover, map, projects, hub, profile
    
    var title: String {
        switch self {
        case .discover: return "Discover"
        case .map: return "Map"
        case .projects: return "Projects"
        case .hub: return "Hub"
        case .profile: return "Profile"
        }
    }
    var icon: String {
        switch self {
        case .discover: return "magnifyingglass"
        case .map: return "map"
        case .projects: return "doc.text"
        case .hub: return "square.grid.3x3"
        case .profile: return "person.crop.circle"
        }
    }
}

// MARK: - Preview
struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfTab(selectedTab: .constant("Profile"))
    }
}
