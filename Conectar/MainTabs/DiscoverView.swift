import SwiftUI

struct DiscoverView: View {
    @Binding var selectedTab: String
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Greeting Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back, Alex! 👋")
                            .font(.title2)
                            .bold()
                        
                        Text("We found new collaborators and projects that match your interests")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    // MARK: - AI-Powered Match Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🤖 AI-Powered Match")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Based on your skills in Machine Learning and interest in Sustainability, we found 3 high-potential projects and 4 collaborators nearby.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Button(action: {}) {
                            HStack {
                                Text("View Recommendations")
                                Image(systemName: "arrow.right")
                            }
                            .font(.subheadline.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color.purple)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(colors: [Color.purple, Color.blue],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // MARK: - Recommended Collaborators
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("👥 Recommended Collaborators")
                                .font(.headline)
                            Spacer()
                            Button("View All") {}
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        VStack(spacing: 16) {
                            CollaboratorCard(
                                name: "Sarah Johnson",
                                location: "San Francisco, CA",
                                description: "UX Designer with a passion for accessible design and AI ethics",
                                tags: ["AI", "Accessibility", "Design"],
                                match: "94%"
                            )
                            
                            CollaboratorCard(
                                name: "Marcus Williams",
                                location: "Oakland, CA",
                                description: "Data scientist building ML models for environmental impact",
                                tags: ["Sustainability", "Climate Tech", "AI"],
                                match: "89%"
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Recommended Projects
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("🧩 Recommended Projects")
                                .font(.headline)
                            Spacer()
                            Button("View All") {}
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        VStack(spacing: 16) {
                            ProjectCard(
                                title: "EcoTrack - Carbon Footprint App",
                                author: "Sarah Johnson",
                                description: "Building a mobile app to help users track and reduce their carbon footprint through daily habit suggestions.",
                                tags: ["Sustainability", "Mobile", "AI"],
                                members: 3,
                                match: "96%"
                            )
                            
                            ProjectCard(
                                title: "OpenCollab - Open Source Project Manager",
                                author: "Emily Park",
                                description: "Creating a tool to help open source maintainers manage contributors and coordinate releases more efficiently.",
                                tags: ["Open Source", "Developer Tools", "Web"],
                                members: 5,
                                match: "91%"
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Explore Section
                    HStack(spacing: 16) {
                        ExploreCard(
                            icon: "map",
                            title: "Explore Map",
                            subtitle: "Discover nearby"
                        )
                        
                        ExploreCard(
                            icon: "sparkles",
                            title: "Start Project",
                            subtitle: "Create new collab"
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            
            // MARK: - Bottom Navigation Bar
            BottomNavBar(selectedTab: $selectedTab)
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        .background(Color(UIColor.systemBackground))
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    DiscoverView(selectedTab: .constant("Discover"))
}
