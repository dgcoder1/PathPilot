//
//  MainTabView.swift
//  PathPilot
//
//  Root tab bar for the main app. Shown after onboarding completes.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.line.uptrend.xyaxis")
                }

            SkillsListView()
                .tabItem {
                    Label("Skills", systemImage: "brain.head.profile")
                }

            CertificationsListView()
                .tabItem {
                    Label("Certifications", systemImage: "rosette")
                }

            ApplicationsListView()
                .tabItem {
                    Label("Applications", systemImage: "briefcase")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .tint(.pathPilotAccent)
    }
}

#Preview {
    MainTabView()
}
