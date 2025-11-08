import SwiftUI

struct BottomNavBar: View {
    @Binding var selectedTab: String
    
    var body: some View {
        HStack {
            Spacer()
            navItem(icon: "magnifyingglass", label: "Discover")
            Spacer()
            navItem(icon: "map", label: "Map")
            Spacer()
            navItem(icon: "folder", label: "Projects")
            Spacer()
            navItem(icon: "bubble.left.and.bubble.right", label: "Chat")
            Spacer()
            navItem(icon: "person.crop.circle", label: "Profile")
            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color(UIColor.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 5, y: -2)
    }
    
    @ViewBuilder
    private func navItem(icon: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(selectedTab == label ? .black : .gray)
            Text(label)
                .font(.caption)
                .foregroundColor(selectedTab == label ? .black : .gray)
        }
        .onTapGesture {
            withAnimation {
                selectedTab = label
            }
        }
    }
}
