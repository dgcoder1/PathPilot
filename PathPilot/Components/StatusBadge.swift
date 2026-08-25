//
//  StatusBadge.swift
//  PathPilot — Components/
//
//  WHAT: Colored capsule pill showing a status label (Planned, Applied, etc.).
//  WHY:  Consistent status styling across cert and application list rows.
//  CONNECTS TO: CertificationsListView, ApplicationsListView.
//  EDIT WHEN: Adding new status enums — add title/color mapping in the private helpers.
//

import SwiftUI

struct StatusBadge: View {
    let text: String
    let color: Color

    // MARK: - Initializers

    /// Fully custom badge — any text + color.
    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }

    /// Certification row badge — maps CertStatus → label + color.
    init(status: CertStatus) {
        self.text = Self.title(for: status)
        self.color = Self.color(for: status)
    }

    /// Application row badge — maps ApplicationStatus → label + color.
    init(applicationStatus: ApplicationStatus) {
        self.text = Self.title(for: applicationStatus)
        self.color = Self.color(for: applicationStatus)
    }

    var body: some View {
        Text(text)
            .font(.caption.weight(.medium))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }

    // MARK: - Certification mapping

    private static func title(for status: CertStatus) -> String {
        switch status {
        case .planned: "Planned"
        case .inProgress: "In Progress"
        case .completed: "Completed"
        }
    }

    private static func color(for status: CertStatus) -> Color {
        switch status {
        case .planned: .secondary
        case .inProgress: .orange
        case .completed: Color.pathPilotAccent
        }
    }

    // MARK: - Application mapping

    private static func title(for status: ApplicationStatus) -> String {
        switch status {
        case .saved: "Saved"
        case .applied: "Applied"
        case .interview: "Interview"
        case .offer: "Offer"
        case .rejected: "Rejected"
        }
    }

    private static func color(for status: ApplicationStatus) -> Color {
        switch status {
        case .saved: .secondary
        case .applied: .blue
        case .interview: .orange
        case .offer: Color.pathPilotAccent
        case .rejected: .red
        }
    }
}

// MARK: - Preview

#Preview("Certification Statuses") {
    VStack(spacing: 12) {
        StatusBadge(status: .planned)
        StatusBadge(status: .inProgress)
        StatusBadge(status: .completed)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color.pathPilotBackground)
}

#Preview("Application Statuses") {
    VStack(spacing: 12) {
        StatusBadge(applicationStatus: .saved)
        StatusBadge(applicationStatus: .applied)
        StatusBadge(applicationStatus: .interview)
        StatusBadge(applicationStatus: .offer)
        StatusBadge(applicationStatus: .rejected)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color.pathPilotBackground)
}

#Preview("Custom Badge") {
    StatusBadge(text: "Custom", color: .purple)
        .padding()
        .background(Color.pathPilotBackground)
}
