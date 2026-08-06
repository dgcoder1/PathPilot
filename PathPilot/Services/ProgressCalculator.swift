//
//  ProgressCalculator.swift
//  PathPilot
//
//  Stateless progress logic for the dashboard progress ring.
//  Weighted formula: skills 40%, certs 30%, milestones 20%, applications 10%.
//

import Foundation

struct ProgressCalculator {

    /// Target number of job applications for the 10% applications slice (Day 6).
    static let applicationGoal = 5

    /// Returns a value from 0.0 (none complete) to 1.0 (all complete).
    static func milestoneProgress(milestones: [Milestone]) -> Double {
        completionRatio(
            completed: milestones.filter(\.isCompleted).count,
            total: milestones.count
        )
    }

    /// Full dashboard progress using weighted categories.
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

        let applicationsComponent = min(
            Double(applicationsSubmitted) / Double(applicationGoal),
            1.0
        ) * 0.10

        return skillsComponent + certificationsComponent + milestonesComponent + applicationsComponent
    }

    private static func completionRatio(completed: Int, total: Int) -> Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
}
