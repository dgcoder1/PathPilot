//
//  Enums.swift
//  PathPilot
//
//  Shared enum types used by SwiftData models.
//  Day 1: skill enums. Day 5: CertStatus. Application enums arrive on Day 6.
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

/// Pipeline state for a certification.
enum CertStatus: String, Codable, CaseIterable {
    case planned
    case inProgress
    case completed
}
