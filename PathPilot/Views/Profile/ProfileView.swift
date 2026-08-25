//
//  ProfileView.swift
//  PathPilot — Views/Profile/
//
//  WHAT: Profile tab — placeholder for Day 6 read-only profile screen.
//  WHY:  Will show name, background, target role, Reset Onboarding, app version.
//  CONNECTS TO: UserProfile, CareerGoal (@Query), RootView (@AppStorage reset).
//  EDIT WHEN: Implementing Task 8 — replace placeholder with live @Query data.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Image(systemName: "person.circle")
                    .font(.largeTitle)
                    .foregroundStyle(Color.pathPilotPrimary)

                Text("Coming soon")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pathPilotBackground)
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
