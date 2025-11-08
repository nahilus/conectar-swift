//
//  SettingsPage.swift
//  Conectar
//
//  Created by Event on 8/11/25.
//


//
//  SettingsPage.swift
//  CollabSphere
//
//  Created by Event on 8/11/25.
//

import SwiftUI

struct SettingsPage: View {
    @State private var showOnMap = true
    @State private var allowInvites = true
    @State private var aiRecommendations = true
    @State private var collaborationStyle = "Team"
    @State private var profileVisibility = "Public"
    @State private var dataSharing = true
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Account
                Section(header: Text("Account")) {
                    NavigationLink(destination: Text("Edit Profile Coming Soon")) {
                        Label("Edit Profile", systemImage: "pencil")
                    }
                    NavigationLink(destination: Text("Change Password Coming Soon")) {
                        Label("Change Password", systemImage: "key.fill")
                    }
                    NavigationLink(destination: Text("Linked Accounts Coming Soon")) {
                        Label("Linked Accounts", systemImage: "link")
                    }
                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .alert("Are you sure you want to log out?", isPresented: $showLogoutAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Log Out", role: .destructive) {}
                    }
                }

                // MARK: - Collaboration Preferences
                Section(header: Text("Collaboration Preferences")) {
                    Toggle(isOn: $showOnMap) {
                        Label("Show Me on Map", systemImage: "mappin.and.ellipse")
                    }

                    Toggle(isOn: $allowInvites) {
                        Label("Allow Collaboration Invites", systemImage: "person.2.fill")
                    }

                    Toggle(isOn: $aiRecommendations) {
                        Label("AI Recommendations", systemImage: "sparkles")
                    }

                    Picker(selection: $collaborationStyle, label: Label("Collaboration Style", systemImage: "person.3.sequence")) {
                        Text("Solo").tag("Solo")
                        Text("Team").tag("Team")
                        Text("Mentor").tag("Mentor")
                        Text("Learner").tag("Learner")
                    }
                }

                // MARK: - Privacy
                Section(header: Text("Privacy")) {
                    Picker(selection: $profileVisibility, label: Label("Profile Visibility", systemImage: "eye")) {
                        Text("Public").tag("Public")
                        Text("Friends Only").tag("Friends Only")
                        Text("Private").tag("Private")
                    }

                    Toggle(isOn: $dataSharing) {
                        Label("Data Sharing for Recommendations", systemImage: "shield.lefthalf.filled")
                    }
                }

                // MARK: - Support & About
                Section(header: Text("Support & About")) {
                    NavigationLink(destination: Text("Help & Support Coming Soon")) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }

                    NavigationLink(destination: Text("Privacy Policy Coming Soon")) {
                        Label("Privacy Policy", systemImage: "lock.shield")
                    }

                    NavigationLink(destination: Text("Version 1.0.0")) {
                        Label("App Version", systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsPage()
}