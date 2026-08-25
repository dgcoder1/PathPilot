//
//  ProgressCalculator.swift
//  PathPilot — Services/
//
//  WHAT: Pure logic that computes dashboard progress percentages.
//  WHY:  Keeps math out of views — easy to test and change weights in one place.
//        Stateless struct (no stored properties) — call static methods from ViewModels.
//  CONNECTS TO: DashboardViewModel.progress → ProgressRingView.
//  EDIT WHEN: Changing weight formula (currently 40/30/20/10) or application goal.
//

import Foundation

struct ProgressCalculator {

    /// Target number of submitted applications for the 10% applications slice.
    static let applicationGoal = 5

    // MARK: - Milestone-only (Day 3 simplified formula — kept for reference/testing)

    /// Returns 0.0–1.0 based on completed milestones only.
    static func milestoneProgress(milestones: [Milestone]) -> Double {
        completionRatio(
            completed: milestones.filter(\.isCompleted).count,
            total: milestones.count
        )
    }

    // MARK: - Full weighted progress (Day 5+)

    /// Full dashboard progress: skills 40%, certs 30%, milestones 20%, applications 10%.
    static func overallProgress(
        skills: [Skill],
        certifications: [Certification],
        milestones: [Milestone],
        applicationsSubmitted: Int = 0
    ) -> Double {
        let skillsComponent = completionRatio(
            completed: skills.filter { $0.status == .completed }.count,
            total: skills.count
        ) * 0.40

        let certificationsComponent = completionRatio(
            completed: certifications.filter { $0.status == .completed }.count,
            total: certifications.count
        ) * 0.30

        let milestonesComponent = completionRatio(
            completed: milestones.filter(\.isCompleted).count,
            total: milestones.count
        ) * 0.20

        // Caps at 100% of the 10% slice once user hits applicationGoal submissions.
        let applicationsComponent = min(
            Double(applicationsSubmitted) / Double(applicationGoal),
            1.0
        ) * 0.10

        return skillsComponent + certificationsComponent + milestonesComponent + applicationsComponent
    }

    /// Safe ratio — returns 0 when there are no items (avoids divide-by-zero).
    private static func completionRatio(completed: Int, total: Int) -> Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
}
