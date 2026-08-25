//
//  CareerGoal.swift
//  PathPilot — Models/
//
//  WHAT: SwiftData model for the user's target role (e.g. "Cloud Security Analyst").
//  WHY:  The career goal drives the dashboard hero card and progress context.
//  CONNECTS TO: OnboardingViewModel, DashboardView, ProfileView.
//  EDIT WHEN: Supporting multiple goals (V2) — add isActive filtering logic.
//

import Foundation
import SwiftData

@Model
final class CareerGoal {

    var targetRole: String
    var createdAt: Date
    /// V1 uses one active goal; isActive flags which goal to show if multiples exist in V2.
    var isActive: Bool

    init(
        targetRole: String = "",
        createdAt: Date = .now,
        isActive: Bool = true
    ) {
        self.targetRole = targetRole
        self.createdAt = createdAt
        self.isActive = isActive
    }
}
