import SwiftUI

struct MapPersonDetailView: View {
    let userId: String
    let distance: Int?
    
    @Environment(\.dismiss) var dismiss
    @State private var profile: UserProfile?
    @State private var isLoading = true
    @State private var isFriend = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading profile...")
                } else if let error = errorMessage {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text("Error Loading Profile")
                            .font(.title2)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("UserID: \(userId)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else if let profile = profile {
                    ScrollView {
                        VStack(spacing: 25) {
                            // Profile Picture
                            Circle()
                                .fill(Color.purple.gradient)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Text(profile.displayName.prefix(1).uppercased())
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .padding(.top)
                            
                            // Display Name
                            Text(profile.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            // Distance (if available)
                            if let distance = distance {
                                HStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.blue)
                                    Text("\(distance) meters away")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            // Description
                            if !profile.description.isEmpty {
                                Text(profile.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            // Skills Section
                            if !profile.skills.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.orange)
                                        Text("Skills")
                                            .font(.headline)
                                    }
                                    
                                    FlowLayout(spacing: 8, lineSpacing: 8) {
                                        ForEach(profile.skills, id: \.self) { skill in
                                            Text(skill)
                                                .font(.subheadline)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.blue.opacity(0.2))
                                                .foregroundColor(.blue)
                                                .cornerRadius(15)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            // Interests Section
                            if !profile.interests.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.pink)
                                        Text("Interests")
                                            .font(.headline)
                                    }
                                    
                                    FlowLayout(spacing: 8, lineSpacing: 8) {
                                        ForEach(profile.interests, id: \.self) { interest in
                                            Text(interest)
                                                .font(.subheadline)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.green.opacity(0.2))
                                                .foregroundColor(.green)
                                                .cornerRadius(15)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            // Add Friend Button
                            if isFriend {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Already Friends")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(10)
                            } else {
                                Button(action: sendFriendRequest) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "person.badge.plus")
                                        Text("Send Friend Request")
                                            .fontWeight(.semibold)
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text("Profile not found")
                            .font(.title2)
                        Text("UserID: \(userId)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Nearby User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Friend Request", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .task {
            await loadProfile()
            await checkFriendStatus()
        }
    }
    
    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        
        print("🔍 Loading profile for userId: \(userId)")
        
        // Try to get mock profile directly first
        if let mockProfile = MockUserData.getProfile(for: userId) {
            print("✅ Found mock profile: \(mockProfile.displayName)")
            profile = mockProfile
            isLoading = false
            return
        }
        
        // If not found in mock data, try the service
        print("⚠️ Not found in MockUserData, trying service...")
        let result = await UserProfileService.shared.getMockProfile(userId: userId)
        
        isLoading = false
        
        if result.success {
            print("✅ Profile loaded from service: \(result.profile?.displayName ?? "unknown")")
            profile = result.profile
        } else {
            print("❌ Failed to load profile: \(result.errorMessage ?? "unknown error")")
            errorMessage = result.errorMessage ?? "Profile not found"
        }
    }
    
    func checkFriendStatus() async {
        print("🔍 Checking friend status for userId: \(userId)")
        isFriend = await FriendService.shared.getMockFriendStatus(userId: userId)
        print("👥 Friend status: \(isFriend)")
    }
    
    func sendFriendRequest() {
        Task {
            let result = await FriendService.shared.sendMockFriendRequest(toUserId: userId)
            alertMessage = result.message ?? "Unknown error"
            showAlert = true
            
            if result.success {
                isFriend = await FriendService.shared.getMockFriendStatus(userId: userId)
            }
        }
    }
}

#Preview {
    MapPersonDetailView(userId: "alice_001", distance: 150)
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    var lineSpacing: CGFloat = 8

    init(spacing: CGFloat = 8, lineSpacing: CGFloat = 8) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX > 0 && currentX + size.width > maxWidth {
                // wrap to next line
                currentX = 0
                currentY += lineHeight + lineSpacing
                lineHeight = 0
            }
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + (currentX == 0 ? 0 : spacing)
        }

        let finalHeight = currentY + lineHeight
        let finalWidth = min(maxWidth, proposal.width ?? maxWidth)
        return CGSize(width: finalWidth.isFinite ? finalWidth : currentX, height: finalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX > 0 && currentX + size.width > maxWidth {
                // wrap to next line
                currentX = 0
                currentY += lineHeight + lineSpacing
                lineHeight = 0
            }

            subview.place(at: CGPoint(x: bounds.minX + currentX, y: bounds.minY + currentY), proposal: ProposedViewSize(width: size.width, height: size.height))

            currentX += size.width + (currentX == 0 ? 0 : spacing)
            lineHeight = max(lineHeight, size.height)
        }
    }
}
