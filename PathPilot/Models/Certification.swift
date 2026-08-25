//
//  Certification.swift
//  PathPilot — Models/
//
//  WHAT: SwiftData model for a certification the user is tracking.
//  WHY:  Certs are the third tracker pillar — progress ring uses completed certs (30% weight).
//  CONNECTS TO: CertificationsListView, CertificationFormView, StatusBadge, ProgressCalculator.
//  EDIT WHEN: Adding cert provider links, exam dates, or study notes (V2).
//

import Foundation
import SwiftData

@Model
final class Certification {

    var name: String
    var status: CertStatus
    var targetDate: Date?      // Optional study target — set in form toggle
    var completedDate: Date?   // Auto-set when status → .completed

    init(
        name: String = "",
        status: CertStatus = .planned,
        targetDate: Date? = nil,
        completedDate: Date? = nil
    ) {
        self.name = name
        self.status = status
        self.targetDate = targetDate
        self.completedDate = completedDate
    }
}
