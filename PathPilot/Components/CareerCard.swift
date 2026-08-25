//
//  CareerCard.swift
//  PathPilot — Components/
//
//  WHAT: Reusable card showing a label + value (e.g. "Your Goal: Cloud Security Analyst").
//  WHY:  Consistent card styling across dashboard — change once, updates everywhere.
//  CONNECTS TO: DashboardView (goal display).
//  EDIT WHEN: Reusing for other summary cards or changing card visual style.
//

import SwiftUI

struct CareerCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.pathPilotPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.pathPilotCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    CareerCard(
        title: "Your Goal",
        value: "Cloud Security Analyst"
    )
    .padding()
    .background(Color.pathPilotBackground)
}
