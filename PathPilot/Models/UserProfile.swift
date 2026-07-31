//
//  UserProfile.swift
//  PathPilot
//
//  Stores who the user is and whether they finished onboarding.
//  Created during onboarding (Day 2) and read by the dashboard and profile tabs.
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
