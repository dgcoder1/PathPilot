//
//  Milestone.swift
//  PathPilot
//
//  A checklist item on the user's career roadmap, e.g. "Complete AWS SAA".
//  Shown on the dashboard; toggling completion updates the progress ring (Day 3).
//

import Foundation
import SwiftData

@Model
final class Milestone {

    var title: String
    var isCompleted: Bool
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
