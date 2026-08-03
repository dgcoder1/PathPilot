//
//  ProgressCalculator.swift
//  PathPilot
//
//  Stateless progress logic for the dashboard progress ring.
//  V1: milestone completion only. Full weighted formula added on Day 5.
//

import Foundation

struct ProgressCalculator {

    /// Returns a value from 0.0 (none complete) to 1.0 (all complete).
    static func milestoneProgress(milestones: [Milestone]) -> Double {
        guard !milestones.isEmpty else { return 0 }
        let completed = milestones.filter(\.isCompleted).count
        return Double(completed) / Double(milestones.count)
    }
}
