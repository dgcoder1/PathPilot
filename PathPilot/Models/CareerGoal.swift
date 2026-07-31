//
//  CareerGoal.swift
//  PathPilot
//
//  The user's target role, e.g. "Cloud Security Analyst".
//  V1 supports one active goal; multiple goals are deferred to V2.
//

import Foundation
import SwiftData

@Model
final class CareerGoal {

    var targetRole: String
    var createdAt: Date
    var isActive: Bool

    init(
        targetRole: String = "",
        createdAt: Date = .now,
        isActive: Bool = true
    ) {
        self.targetRole = targetRole
        self.createdAt = createdAt
        self.isActive = isActive
    }
}
