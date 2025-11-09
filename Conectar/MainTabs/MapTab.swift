import SwiftUI
import CoreLocation

struct MapTab: View {
    @Binding var selectedTab: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Map view displaying user + nearby collaborators
            // Using mock data - replace with real database locations later
            MapView(otherPeople: MockUserData.otherPeopleLocations)
                .ignoresSafeArea()
            
            // Bottom navigation bar (shared component)
            BottomNavBar(selectedTab: $selectedTab)
                .padding(.horizontal)
                .padding(.bottom, 8)
                .background(Color(UIColor.systemBackground))
        }
    }
}

#Preview {
    MapTab(selectedTab: .constant("Discover"))
}
