//
//  MainTabView.swift
//  PathPilot — Views/
//
//  WHAT: Bottom tab bar with all five main screens.
//  WHY:  Primary navigation after onboarding — one tab per career tracker area.
//  CONNECTS TO: DashboardView, SkillsListView, CertificationsListView,
//               ApplicationsListView, ProfileView.
//  EDIT WHEN: Adding/removing tabs or changing tab icons/labels.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Tab 1 — hero screen: progress ring, milestones, quick stats.
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.line.uptrend.xyaxis")
                }

            // Tab 2 — skills CRUD with Current / To Learn segments.
            SkillsListView()
                .tabItem {
                    Label("Skills", systemImage: "brain.head.profile")
                }

            // Tab 3 — certification tracker with status badges.
            CertificationsListView()
                .tabItem {
                    Label("Certifications", systemImage: "rosette")
                }

            // Tab 4 — job application pipeline (Day 6).
            ApplicationsListView()
                .tabItem {
                    Label("Applications", systemImage: "briefcase")
                }

            // Tab 5 — read-only profile + reset onboarding (Day 6).
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
