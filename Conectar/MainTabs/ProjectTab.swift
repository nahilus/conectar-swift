import SwiftUI

struct Project: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let description: String
    let tags: [String]
    let members: Int
    let progress: Int
    let status: String
}

struct ProjectTab: View {
    @State private var selectedTab = "Projects"
    @State private var searchText = ""

    var body: some View {
        TabView(selection: $selectedTab) {
            
            // MARK: Discover Tab
            Text("Discover Page")
                .tabItem {
                    Image(systemName: selectedTab == "Discover" ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                    Text("Discover")
                }
                .tag("Discover")
            
            // MARK: Map Tab
            Text("Map Page")
                .tabItem {
                    Image(systemName: selectedTab == "Map" ? "map.fill" : "map")
                    Text("Map")
                }
                .tag("Map")
            
            // MARK: Projects Tab
            ProjectsView(searchText: $searchText)
                .tabItem {
                    Image(systemName: selectedTab == "Projects" ? "folder.fill" : "folder")
                    Text("Projects")
                }
                .tag("Projects")
            
            // MARK: Hub Tab
            Text("Hub Page")
                .tabItem {
                    Image(systemName: selectedTab == "Hub" ? "square.grid.2x2.fill" : "square.grid.2x2")
                    Text("Hub")
                }
                .tag("Hub")
            
            // MARK: Profile Tab
            Text("Profile Page")
                .tabItem {
                    Image(systemName: selectedTab == "Profile" ? "person.crop.circle.fill" : "person.crop.circle")
                    Text("Profile")
                }
                .tag("Profile")
        }
        .tint(.black) // makes selected tab icons and text black
    }
}

struct ProjectsView: View {
    @Binding var searchText: String
    
    let projects = [
        Project(title: "EcoTrack - Carbon Footprint App",
                author: "Sarah Johnson",
                description: "Building a mobile app to help users track and reduce their carbon footprint through daily habit suggestions.",
                tags: ["Sustainability", "Mobile", "AI", "React Native"],
                members: 3,
                progress: 96,
                status: "open"),
        
        Project(title: "OpenCollab - Open Source Project Manager",
                author: "Emily Park",
                description: "Creating a tool to help open source maintainers manage contributors and coordinate releases more efficiently.",
                tags: ["Open Source", "Developer Tools", "Web"],
                members: 5,
                progress: 91,
                status: "active"),
        
        Project(title: "AI Ethics Framework",
                author: "Marcus Williams",
                description: "Designing an ethical framework for AI model deployment with transparency and accountability principles.",
                tags: ["AI", "Ethics", "Research"],
                members: 4,
                progress: 88,
                status: "active")
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                
                // MARK: Header
                HStack {
                    Text("Projects")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create")
                        }
                        .font(.subheadline)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 14)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Text("Discover projects or start your own")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding(.horizontal)
                
                // MARK: Search Bar
                TextField("Search projects...", text: $searchText)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // MARK: Project List
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(projects.filter { searchText.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(searchText) }) { project in
                            ProjectCard(project: project)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: Project Card
struct ProjectCard: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Title + Status
            HStack {
                Text(project.title)
                    .font(.headline)
                Spacer()
                HStack(spacing: 4) {
                    Text("\(project.progress)%")
                        .font(.caption)
                        .padding(4)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(6)
                    Text(project.status)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
            
            Text("by \(project.author)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(project.description)
                .font(.body)
                .lineLimit(2)
            
            HStack {
                ForEach(project.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
            }
            
            Divider()
            
            HStack {
                Label("\(project.members) members", systemImage: "person.3")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {}) {
                    Text("Join")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color(UIColor.systemGray4).opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ProjectTab()
}
