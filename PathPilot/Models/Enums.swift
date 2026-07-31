//
//  Enums.swift
//  PathPilot
//
//  Shared enum types used by SwiftData models.
//  Day 1: skill enums only. Cert and application enums arrive on feature days.
//

import Foundation

/// Whether a skill is something the user already has or wants to learn.
enum SkillCategory: String, Codable, CaseIterable {
    case current
    case toLearn
}

/// Progress state for a single skill.
enum SkillStatus: String, Codable, CaseIterable {
    case notStarted
    case inProgress
    case completed
}
