//
//  MapTab.swift
//  Conectar
//
//  Created by Beautiful princess ❤️
//

import SwiftUI
import CoreLocation

struct MapTab: View {
    // Mock data — you’ll later replace this with database locations
    let otherPeopleLocations: [(name: String, coordinate: CLLocationCoordinate2D)] = [
        ("Alice",   CLLocationCoordinate2D(latitude: 1.3523, longitude: 103.8196)), // Example near Singapore
        ("Bob",     CLLocationCoordinate2D(latitude: 1.3530, longitude: 103.8205)),
        ("Charlie", CLLocationCoordinate2D(latitude: 1.3540, longitude: 103.8210)),
        ("David",   CLLocationCoordinate2D(latitude: 1.3518, longitude: 103.8189)),
        ("Eve",     CLLocationCoordinate2D(latitude: 1.3538, longitude: 103.8202))
    ]
    
    @Binding var selectedTab: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Map view displaying user + nearby collaborators
            MapView(otherPeople: otherPeopleLocations)
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
