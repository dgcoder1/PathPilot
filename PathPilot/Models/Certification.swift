//
//  Certification.swift
//  PathPilot
//
//  A certification the user is planning, studying for, or has earned,
//  e.g. "AWS Solutions Architect". Managed on the Certifications tab (Day 5).
//

import Foundation
import SwiftData

@Model
final class Certification {

    var name: String
    var status: CertStatus
    var targetDate: Date?
    var completedDate: Date?

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
