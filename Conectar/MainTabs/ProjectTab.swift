import SwiftUI

struct ProjectTab: View {
    @Binding var selectedTab: String
    
    // Example data — replace with your actual project model or data source
    let sampleProjects = [
        ("AI Safety Assistant", "An AI-driven tool that enhances emergency response systems.", "Team Nova", ["AI", "ML", "Emergency"], 5, 0.92),
        ("EcoTrack", "A mobile app for tracking personal sustainability efforts.", "EcoTech Labs", ["IoT", "Environment", "Mobile"], 3, 0.87),
        ("ConnectAR", "A social AR platform that connects innovators and engineers.", "VisionAR", ["AR", "Social", "Networking"], 4, 0.90),
        ("SmartBin", "IoT-based waste management with real-time fill detection.", "GreenBin Co.", ["IoT", "Sensors", "Sustainability"], 6, 0.85)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Title/Header
            Text("Projects")
                .font(.largeTitle.bold())
                .padding(.top, 50)
            
            // Scrollable Project List
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(sampleProjects, id: \.0) { project in
                        ProjectCard(
                            title: project.0,
                            author: project.1,
                            description: project.2,
                            tags: project.3,
                            members: project.4,
                            match: String(project.5)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 80) // leave space for bottom nav
            }
            
            // Bottom Navigation Bar
            BottomNavBar(selectedTab: $selectedTab)
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ProjectTab(selectedTab: .constant("Projects"))
}
