//
//  DashboardViewModel.swift
//  PathPilot — ViewModels/
//
//  WHAT: Prepares display-ready data for the dashboard from raw SwiftData models.
//  WHY:  MVVM keeps DashboardView thin — view fetches with @Query, VM formats for UI.
//        Uses @Observable (iOS 17+) instead of ObservableObject/@Published.
//  CONNECTS TO: DashboardView calls update(...) when @Query data changes.
//  EDIT WHEN: Adding new dashboard sections or wiring live application count (Task 9).
//

import Foundation
import Observation

@Observable
final class DashboardViewModel {

    // MARK: - Source data (synced from @Query in DashboardView)

    private(set) var profile: UserProfile?
    private(set) var goal: CareerGoal?
    private(set) var milestones: [Milestone] = []
    private(set) var skills: [Skill] = []
    private(set) var certifications: [Certification] = []

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

    /// 0.0–1.0 fraction fed to ProgressRingView.
    var progress: Double {
        ProgressCalculator.overallProgress(
            skills: skills,
            certifications: certifications,
            milestones: milestones,
            applicationsSubmitted: applicationsCount
        )
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

    var skillsCount: Int { skills.count }
    var certificationsCount: Int { certifications.count }

    /// TODO (Task 9): Wire to live @Query JobApplication count — currently hardcoded 0.
    var applicationsCount: Int { 0 }

    // MARK: - Sync

    /// DashboardView calls this inside .task(id: syncToken) whenever @Query results change.
    func update(
        profile: UserProfile?,
        goal: CareerGoal?,
        milestones: [Milestone],
        skills: [Skill],
        certifications: [Certification]
    ) {
        self.profile = profile
        self.goal = goal
        self.milestones = milestones
        self.skills = skills
        self.certifications = certifications
    }
}
