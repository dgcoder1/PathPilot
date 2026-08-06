//
//  StatusBadge.swift
//  PathPilot
//
//  Reusable status pill for list rows (Certifications Day 5, Applications Day 6).
//  Accepts custom text and color, or a CertStatus for certification rows.
//

import SwiftUI

struct StatusBadge: View {
    let text: String
    let color: Color

    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }

    init(status: CertStatus) {
        self.text = Self.title(for: status)
        self.color = Self.color(for: status)
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

    private static func title(for status: CertStatus) -> String {
        switch status {
        case .planned:
            "Planned"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }

    private static func color(for status: CertStatus) -> Color {
        switch status {
        case .planned:
            .secondary
        case .inProgress:
            .orange
        case .completed:
            Color.pathPilotAccent
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

#Preview("Custom Badge") {
    StatusBadge(text: "Applied", color: .blue)
        .padding()
        .background(Color.pathPilotBackground)
}
