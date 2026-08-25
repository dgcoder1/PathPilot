//
//  RootView.swift
//  PathPilot — Views/
//
//  WHAT: Top-level router shown at launch.
//  WHY:  First-time users need onboarding; returning users skip straight to tabs.
//        @AppStorage is the gate — fast to read, survives app restarts.
//  CONNECTS TO: OnboardingContainerView (new users), MainTabView (returning users).
//  EDIT WHEN: Changing launch flow (e.g. login screen in V2).
//

import SwiftUI

struct RootView: View {

    // UserDefaults flag set to true when onboarding finishes.
    // Separate from SwiftData — used only for routing, not profile data.
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
