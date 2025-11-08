//
//  ConectarApp.swift
//  Conectar
//
//  Created by Event on 8/11/25.
//

import SwiftUI
import FirebaseCore

@main
struct ConectarApp: App {
    @State private var selectedTab: String = "Discover"
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LandingView()
        }
    }
}

