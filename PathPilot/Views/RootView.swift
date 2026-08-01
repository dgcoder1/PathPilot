//
//  RootView.swift
//  PathPilot
//
//  Top-level view that decides what the user sees at launch.
//  First-time users see onboarding; returning users go straight to the tabs.
//

import SwiftUI

struct RootView: View {

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingContainerView()
        }
    }
}

#Preview {
    RootView()
}
