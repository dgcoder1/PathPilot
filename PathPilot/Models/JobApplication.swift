//
//  JobApplication.swift
//  PathPilot — Models/
//
//  WHAT: SwiftData model for a job the user is tracking through the hiring pipeline.
//  WHY:  Applications complete the career pipeline — progress ring uses submitted count (10%).
//  CONNECTS TO: ApplicationsListView, ApplicationFormView (Task 4+), StatusBadge, ProgressCalculator.
//  EDIT WHEN: Adding interview dates, contacts, or grouped list sections (V2).
//

import Foundation
import SwiftData

@Model
final class JobApplication {

    var company: String
    var roleTitle: String
    var status: ApplicationStatus
    var appliedDate: Date?   // Set when status is Applied or later; cleared if back to Saved
    var notes: String?       // Optional — skip in V1 if behind schedule

    init(
        company: String = "",
        roleTitle: String = "",
        status: ApplicationStatus = .saved,
        appliedDate: Date? = nil,
        notes: String? = nil
    ) {
        self.company = company
        self.roleTitle = roleTitle
        self.status = status
        self.appliedDate = appliedDate
        self.notes = notes
    }
}
