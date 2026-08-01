//
//  Skill.swift
//  PathPilot
//
//  A skill the user already has or wants to learn, e.g. "Python" or "AWS".
//  Created during onboarding (Day 2) and managed on the Skills tab (Day 4).
//

import Foundation
import SwiftData

@Model
final class Skill {

    var name: String
    var category: SkillCategory
    var status: SkillStatus
    var createdAt: Date

    init(
        name: String = "",
        category: SkillCategory = .current,
        status: SkillStatus = .notStarted,
        createdAt: Date = .now
    ) {
        self.name = name
        self.category = category
        self.status = status
        self.createdAt = createdAt
    }
}
