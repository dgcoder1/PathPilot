//
//  DashboardViewModel.swift
//  PathPilot
//
//  Prepares dashboard display data from SwiftData models.
//  DashboardView fetches with @Query and calls update(...); this type owns computed UI values.
//

import Foundation
import Observation

@Observable
final class DashboardViewModel {

    // MARK: - Source data (synced from @Query in DashboardView)

    private(set) var profile: UserProfile?
    private(set) var goal: CareerGoal?
    private(set) var milestones: [Milestone] = []
    private(set) var skillsCount: Int = 0

    // MARK: - Display copy

    var userName: String {
        let trimmed = profile?.name.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? "there" : trimmed
    }

    var welcomeMessage: String {
        "Welcome back, \(userName)"
    }

    var targetRole: String {
        let trimmed = goal?.targetRole.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? "Set your goal" : trimmed
    }

    // MARK: - Progress

    var progress: Double {
        ProgressCalculator.milestoneProgress(milestones: milestones)
    }

    var sortedMilestones: [Milestone] {
        milestones.sorted { lhs, rhs in
            if lhs.sortOrder != rhs.sortOrder {
                return lhs.sortOrder < rhs.sortOrder
            }
            return lhs.createdAt < rhs.createdAt
        }
    }

    // MARK: - Quick stats

    /// Certification model arrives on Day 5 — count stays 0 until then.
    var certificationsCount: Int { 0 }

    /// Job application model arrives on Day 6 — count stays 0 until then.
    var applicationsCount: Int { 0 }

    // MARK: - Sync

    /// Call when @Query results change so computed properties stay in sync with SwiftData.
    func update(
        profile: UserProfile?,
        goal: CareerGoal?,
        milestones: [Milestone],
        skills: [Skill]
    ) {
        self.profile = profile
        self.goal = goal
        self.milestones = milestones
        self.skillsCount = skills.count
    }
}
