import SwiftUI
import CoreLocation

struct MapTab: View {
    @Binding var selectedTab: String
    // 1. Use the DataMapper to load and transform the mock data into the required [User] format.
    private let allUsers: [User] = DataMapper.mapMockDataToUsers()
    
    // 2. Designate a "current user" from the mapped list for demonstration.
    private var currentUser: User {
        // We'll select 'Alice Chen' as the current user for this example.
        // Finding the user by name makes this robust.
        guard let user = allUsers.first(where: { $0.name == "Alice Chen" }) else {
            // As a fallback, if Alice isn't found, use the first user.
            // In a real app, this would be based on the logged-in user.
            fatalError("Could not find the current user in the mapped data.")
        }
        return user
    }
    var body: some View {
        VStack(spacing: 0) {
            // Map view displaying user + nearby collaborators
            // Using mock data - replace with real database locations later
            MapView(currentUser: currentUser, allUsers: allUsers)
            
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
