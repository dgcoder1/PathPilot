//
//  JobApplication.swift
//  PathPilot
//
//  A job the user is tracking through the application pipeline,
//  e.g. "Acme Corp — Cloud Security Analyst". Managed on the Applications tab (Day 6).
//

import Foundation
import SwiftData

@Model
final class JobApplication {

    var company: String
    var roleTitle: String
    var status: ApplicationStatus
    var appliedDate: Date?
    var notes: String?

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
