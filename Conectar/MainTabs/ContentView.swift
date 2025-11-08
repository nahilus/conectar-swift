import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "Discover"
    
    var body: some View {
        switch selectedTab {
        case "Discover":
            DiscoverView(selectedTab: $selectedTab)
        case "Projects":
            ProjectTab(selectedTab: $selectedTab)
        case "Chat":
            ChatTab(selectedTab: $selectedTab)
        case "Profile":
            ProfileTab(selectedTab: $selectedTab)
        default:
            DiscoverView(selectedTab: $selectedTab)
        }
    }
}
