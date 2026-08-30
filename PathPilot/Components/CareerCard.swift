//
//  CareerCard.swift
//  PathPilot — Components/
//
//  WHAT: Goal hero card — role title, overall progress ring, and a View action.
//  WHY:  Dashboard lead visual — target role and progress in one place.
//  CONNECTS TO: DashboardView (goal + ProgressRingView).
//  EDIT WHEN: Changing goal-card layout or the View button destination.
//

import SwiftUI

struct CareerCard: View {
    let title: String
    let value: String
    var progress: Double = 0
    var encouragement: String = "Keep going, you're building your future."
    var onView: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .tracking(0.6)

                    Text(value)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Color.pathPilotPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 8)

                VStack(alignment: .trailing, spacing: 8) {
                    if let onView {
                        Button(action: onView) {
                            HStack(spacing: 4) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                Text("View")
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.pathPilotPrimary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.pathPilotPrimary.opacity(0.08))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Opens Profile")
                    }

                    ProgressRingView(
                        progress: progress,
                        lineWidth: 10,
                        size: 108,
                        centerSubtitle: "Overall Progress"
                    )
                    .animation(.easeInOut(duration: 0.35), value: progress)
                }
            }

            HStack(spacing: 8) {
                Image(systemName: "target")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.pathPilotPrimary)
                    .accessibilityHidden(true)

                Text(encouragement)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(Color.pathPilotCard)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    CareerCard(
        title: "Your Goal",
        value: "Cloud Security Analyst",
        progress: 0.26
    )
    .padding()
    .background(Color.pathPilotBackground)
}
