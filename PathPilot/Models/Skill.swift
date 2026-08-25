//
//  Skill.swift
//  PathPilot — Models/
//
//  WHAT: SwiftData model for a single skill (current or to-learn).
//  WHY:  Skills are a core tracker — progress ring uses completed skills (40% weight).
//  CONNECTS TO: SkillsListView, SkillFormView, OnboardingViewModel, ProgressCalculator.
//  EDIT WHEN: Adding skill notes, categories, or detail view (V2).
//

import Foundation
import SwiftData

@Model
final class Skill {

    var name: String
    var category: SkillCategory   // .current or .toLearn — drives segmented list filter
    var status: SkillStatus       // Tappable pill on list rows cycles this
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
