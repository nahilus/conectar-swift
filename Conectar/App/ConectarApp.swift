//
//  ConectarApp.swift
//  Conectar
//
//  Created by Event on 8/11/25.
//

import SwiftUI

@main
struct ConectarApp: App {
    @State private var selectedTab: String = "Discover"
    var body: some Scene {
        WindowGroup {
            ProjectTab(selectedTab: $selectedTab)
        }
    }
}

