//
//  Milestone.swift
//  PathPilot — Models/
//
//  WHAT: SwiftData model for a career roadmap checklist item.
//  WHY:  Milestones are the "next steps" on the dashboard; toggling them updates progress.
//  CONNECTS TO: DashboardView (checklist + progress ring), ProgressCalculator (20% weight).
//  EDIT WHEN: Adding due dates, notifications, or reorder UI (V2).
//

import Foundation
import SwiftData

@Model
final class Milestone {

    var title: String
    var isCompleted: Bool
    /// Controls display order on the dashboard checklist.
    var sortOrder: Int
    var createdAt: Date

    init(
        title: String = "",
        isCompleted: Bool = false,
        sortOrder: Int = 0,
        createdAt: Date = .now
    ) {
        self.title = title
        self.isCompleted = isCompleted
        self.sortOrder = sortOrder
        self.createdAt = createdAt
    }
}
