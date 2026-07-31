//
//  CareerCard.swift
//  PathPilot
//
//  Reusable card for displaying career goal and similar summary content.
//  Used on the dashboard (Day 3).
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
