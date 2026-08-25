//
//  Enums.swift
//  PathPilot — Models/
//
//  WHAT: Shared enum types for SwiftData model properties.
//  WHY:  Enums give type-safe status/category values instead of raw strings.
//        Codable + String raw values let SwiftData persist them in the database.
//        CaseIterable enables ForEach in pickers (status dropdowns in forms).
//  CONNECTS TO: Skill, Certification, JobApplication models and their list/form views.
//  EDIT WHEN: Adding a new status case — update StatusBadge mapping too.
//

import Foundation

// MARK: - Skills (Day 2 / Day 4)

/// Whether a skill is something the user already has or wants to learn.
enum SkillCategory: String, Codable, CaseIterable {
    case current   // Skills tab → "Current" segment
    case toLearn   // Skills tab → "To Learn" segment
}

/// Progress state for a single skill row.
enum SkillStatus: String, Codable, CaseIterable {
    case notStarted
    case inProgress
    case completed
}

// MARK: - Certifications (Day 5)

/// Pipeline state for a certification.
enum CertStatus: String, Codable, CaseIterable {
    case planned
    case inProgress
    case completed
}

// MARK: - Applications (Day 6)

/// Pipeline state for a job application (Saved → Applied → Interview → Offer / Rejected).
enum ApplicationStatus: String, Codable, CaseIterable {
    case saved
    case applied
    case interview
    case offer
    case rejected
}
