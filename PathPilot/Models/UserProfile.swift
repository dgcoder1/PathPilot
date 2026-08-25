//
//  UserProfile.swift
//  PathPilot — Models/
//
//  WHAT: SwiftData model for the user's identity (name, background).
//  WHY:  Persists who the user is after onboarding — shown on Dashboard and Profile.
//  CONNECTS TO: OnboardingViewModel (creates on finish), DashboardView, ProfileView.
//  EDIT WHEN: Adding profile fields (e.g. email in V2).
//

import Foundation
import SwiftData

@Model
final class UserProfile {

    var name: String
    var currentBackground: String
    var createdAt: Date
    var hasCompletedOnboarding: Bool

    init(
        name: String = "",
        currentBackground: String = "",
        createdAt: Date = .now,
        hasCompletedOnboarding: Bool = false
    ) {
        self.name = name
        self.currentBackground = currentBackground
        self.createdAt = createdAt
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}
