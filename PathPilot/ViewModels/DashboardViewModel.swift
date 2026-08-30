//
//  DashboardViewModel.swift
//  PathPilot — ViewModels/
//
//  WHAT: Prepares display-ready data for the dashboard from raw SwiftData models.
//  WHY:  MVVM keeps DashboardView thin — view fetches with @Query, VM formats for UI.
//        Uses @Observable (iOS 17+) instead of ObservableObject/@Published.
//  CONNECTS TO: DashboardView calls update(...) when @Query data changes.
//  EDIT WHEN: Adding new dashboard sections or changing how counts/progress are derived.
//

import Foundation
import Observation
import SwiftData

@Observable
final class DashboardViewModel {

    // MARK: - Source data (synced from @Query in DashboardView)

    private(set) var profile: UserProfile?
    private(set) var goal: CareerGoal?
    private(set) var milestones: [Milestone] = []
    private(set) var skills: [Skill] = []
    private(set) var certifications: [Certification] = []
    private(set) var applications: [JobApplication] = []

    // MARK: - Display copy

    var userName: String {
        let trimmed = profile?.name.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? "there" : trimmed
    }

    var welcomeMessage: String {
        "\(timeOfDayGreeting), \(userName)"
    }

    private var timeOfDayGreeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: "Good morning"
        case 12..<17: "Good afternoon"
        default: "Good evening"
        }
    }

    /// First letters of the name for the header avatar (no photo in V1).
    var userInitials: String {
        let parts = userName.split(whereSeparator: { !$0.isLetter }).filter { !$0.isEmpty }
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(userName.prefix(1)).uppercased()
    }

    var targetRole: String {
        let trimmed = goal?.targetRole.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? "Set your goal" : trimmed
    }

    var progressPercent: Int {
        Int(progress * 100)
    }

    var encouragementTitle: String {
        switch progress {
        case 0:
            return "Let's build your path"
        case ..<0.25:
            return "Great start!"
        case ..<0.75:
            return "You're on the right track!"
        default:
            return "You're almost there!"
        }
    }

    var encouragementMessage: String {
        "Keep going, you're building your future."
    }

    /// First unfinished milestone, or the first one if all are done.
    var nextMilestone: Milestone? {
        sortedMilestones.first { !$0.isCompleted } ?? sortedMilestones.first
    }

    // MARK: - Progress

    /// 0.0–1.0 fraction fed to ProgressRingView.
    var progress: Double {
        ProgressCalculator.overallProgress(
            skills: skills,
            certifications: certifications,
            milestones: milestones,
            applicationsSubmitted: applicationsSubmittedCount
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

    /// Overview tiles — labels match these counts (Tracking / Earned / In Progress).
    var skillsCount: Int { skills.count }
    var certificationsCount: Int { certifications.filter { $0.status == .completed }.count }
    var applicationsCount: Int {
        applications.filter { $0.status == .applied || $0.status == .interview || $0.status == .offer }.count
    }

    /// Applied / Interview / Offer / Rejected — Saved jobs don't count toward the 10% slice.
    var applicationsSubmittedCount: Int {
        applications.filter { $0.status != .saved }.count
    }

    // MARK: - Recently updated

    var recentItems: [RecentActivityItem] {
        var items: [RecentActivityItem] = []

        items += skills.map { skill in
            RecentActivityItem(
                id: "skill-\(skill.persistentModelID)",
                title: skill.name,
                subtitle: "Skill",
                date: skill.createdAt,
                kind: .skill
            )
        }

        items += certifications.map { cert in
            RecentActivityItem(
                id: "cert-\(cert.persistentModelID)",
                title: cert.name,
                subtitle: "Certification",
                date: cert.completedDate ?? cert.targetDate ?? .now,
                kind: .certification
            )
        }

        items += applications.map { application in
            RecentActivityItem(
                id: "app-\(application.persistentModelID)",
                title: application.roleTitle,
                subtitle: application.company,
                date: application.appliedDate ?? .now,
                kind: .application
            )
        }

        return Array(items.sorted { $0.date > $1.date }.prefix(3))
    }

    // MARK: - Sync

    /// DashboardView calls this inside .task(id: syncToken) whenever @Query results change.
    func update(
        profile: UserProfile?,
        goal: CareerGoal?,
        milestones: [Milestone],
        skills: [Skill],
        certifications: [Certification],
        applications: [JobApplication]
    ) {
        self.profile = profile
        self.goal = goal
        self.milestones = milestones
        self.skills = skills
        self.certifications = certifications
        self.applications = applications
    }
}

/// One row in the dashboard "Recently Updated" list.
struct RecentActivityItem: Identifiable {
    enum Kind {
        case skill
        case certification
        case application
    }

    let id: String
    let title: String
    let subtitle: String
    let date: Date
    let kind: Kind

    var relativeDateText: String {
        let minutes = Date.now.timeIntervalSince(date) / 60
        if minutes < 60 { return "Just now" }
        return RelativeDateTimeFormatter().localizedString(for: date, relativeTo: .now)
    }
}
