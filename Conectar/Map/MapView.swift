
import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198),
            span: MKCoordinateSpan(latitudeDelta: 0.018, longitudeDelta: 0.018)
        )
    )
    @State private var selectedPerson: MapPerson?  // ADD THIS
    @State private var showPersonDetails = false    // ADD THIS
    
    var otherPeople: [(name: String, userId: String, coordinate: CLLocationCoordinate2D)]
    
    var body: some View {
        Map(position: $region) {
            // User annotation
            if let userLocation = locationManager.lastKnownLocation {
                Annotation("You", coordinate: userLocation) {
                    Image("cookiejar")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
            
            // Other people
            ForEach(otherPeople, id: \.name) { person in
                Annotation(person.name, coordinate: person.coordinate) {
                    Button(action: {
                        // When tapped, show their details
                        selectedPerson = MapPerson(
                            name: person.name,
                            userId: person.userId, // You'll replace this with actual userId
                            coordinate: person.coordinate
                        )
                        showPersonDetails = true
                    }) {
                        VStack {
                            Image(systemName: "person.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            if let userLocation = locationManager.lastKnownLocation {
                                let distanceInMeters = distance(from: userLocation, to: person.coordinate)
                                Text("\(Int(distanceInMeters)) m away")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }
        .mapControls { MapUserLocationButton() }
        .onAppear { locationManager.checkLocationAuthorization() }
        .onReceive(locationManager.$lastKnownLocation) { newLocation in
            if let location = newLocation {
                region = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: location,
                        span: MKCoordinateSpan(latitudeDelta: 0.018, longitudeDelta: 0.018)
                    )
                )
            }
        }
        .sheet(isPresented: $showPersonDetails) {  // ADD THIS SHEET
            if let person = selectedPerson {
                MapPersonDetailView(
                    userId: person.userId,
                    distance: locationManager.lastKnownLocation.map {
                        Int(distance(from: $0, to: person.coordinate))
                    }
                )
            }
        }
    }
    
    // Distance helper
    private func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let loc1 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let loc2 = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return loc1.distance(from: loc2)
    }
}

// ADD THIS STRUCT
struct MapPerson {
    let name: String
    let userId: String
    let coordinate: CLLocationCoordinate2D
}


