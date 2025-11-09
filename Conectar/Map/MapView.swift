// FILE: MapView.swift

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    // MARK: - State Properties
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel: RecommendationViewModel
    @State private var region: MapCameraPosition
    @State private var selectedMatch: UserMatch?

    // MARK: - Initializer
    init(currentUser: User, allUsers: [User]) {
        _viewModel = StateObject(wrappedValue: RecommendationViewModel(currentUser: currentUser, allUsers: allUsers))

        let initialRegion = MKCoordinateRegion(
            center: currentUser.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        _region = State(initialValue: .region(initialRegion))
    }

    // MARK: - Body
    var body: some View {
        Map(position: $region) {
            // Annotation for the Current User's PROFILE Location
            Annotation("Your Profile Location", coordinate: viewModel.currentUser.coordinate) {
                VStack(spacing: 2) {
                    Image(systemName: "star.circle.fill")
                        .font(.title).foregroundColor(.white).background(Color.red)
                        .clipShape(Circle()).shadow(radius: 3)
                    Text("You").font(.caption).bold().padding(3)
                        .background(.red).foregroundColor(.white).cornerRadius(5)
                }
            }
            
            // Annotation for the User's LIVE GPS Location (if available)
            if let liveLocation = locationManager.lastKnownLocation {
                Annotation("Current Location", coordinate: liveLocation) {
                    Image(systemName: "location.circle.fill")
                        .font(.largeTitle).foregroundColor(.blue).shadow(radius: 3)
                }
            }

            // Annotations for all Recommended Users
            ForEach(viewModel.recommendations) { match in
                Annotation(match.user.name, coordinate: match.user.coordinate) {
                    Button(action: {
                        selectedMatch = match
                    }) {
                        VStack(spacing: 2) {
                            Image(systemName: "person.fill")
                                .font(.title).foregroundColor(.white).padding(5)
                                .background(matchColor(for: match.score))
                                .clipShape(Circle()).shadow(radius: 3)
                            
                            Text("\(Int(match.score * 100))%")
                                .font(.caption).bold().padding(.horizontal, 5).padding(.vertical, 2)
                                .background(matchColor(for: match.score))
                                .foregroundColor(.white).cornerRadius(6)
                        }
                    }
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapPitchToggle()
        }
        .onAppear {
            locationManager.checkLocationAuthorization()
            viewModel.loadRecommendations()
        }
        // [MODIFIED] The sheet modifier now calls your advanced 'MapPersonDetailView'.
        .sheet(item: $selectedMatch) { match in
            MapPersonDetailView(
                userId: match.user.userId, // Pass the userId we added to the User model.
                distance: calculateDistance(to: match.user.coordinate) // Pass the calculated distance.
            )
        }
    }

    // MARK: - Helper Methods
    
    /// Determines the color of a user's pin based on their match score.
    private func matchColor(for score: Double) -> Color {
        if score > 0.4 { return .green }
        else if score > 0.2 { return .orange }
        else { return .cyan }
    }
    
    // [+ADD] New helper function to calculate the distance from the user's live location.
    /// This keeps the sheet modifier code clean.
    private func calculateDistance(to coordinate: CLLocationCoordinate2D) -> Int? {
        guard let userLocation = locationManager.lastKnownLocation else {
            return nil // Return nil if the user's live location is not available.
        }
        
        let loc1 = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let loc2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        return Int(loc1.distance(from: loc2))
    }
}

// MARK: - Preview
struct MapView_Previews: PreviewProvider {
    static let allUsers = DataMapper.mapMockDataToUsers()
    static let currentUser = allUsers.first(where: { $0.name == "Alice Chen" })!

    static var previews: some View {
        MapView(currentUser: currentUser, allUsers: allUsers)
    }
}
