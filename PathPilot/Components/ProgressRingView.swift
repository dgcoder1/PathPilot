//
//  ProgressRingView.swift
//  PathPilot — Components/
//
//  WHAT: Circular progress ring with percentage label in the center.
//  WHY:  Dashboard hero visual — shows overall career progress at a glance.
//  CONNECTS TO: DashboardView passes viewModel.progress (0.0–1.0).
//  EDIT WHEN: Adding animation (Day 7), accessibility labels, or size variants.
//

import SwiftUI

struct ProgressRingView: View {

    /// Completion fraction from 0.0 (empty ring) to 1.0 (full ring).
    let progress: Double
    var lineWidth: CGFloat = 12
    var size: CGFloat = 140

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack {
            // Background track — always full circle, faint primary color.
            Circle()
                .trim(from: 0, to: 1)
                .stroke(
                    Color.pathPilotPrimary.opacity(0.15),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))   // Start at 12 o'clock

            // Foreground arc — grows with progress.
            Circle()
                .trim(from: 0, to: clampedProgress)
                .stroke(
                    Color.pathPilotAccent,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Text("\(Int(clampedProgress * 100))%")
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.pathPilotPrimary)
        }
        .frame(width: size, height: size)
    }
}

#Preview("Progress states") {
    HStack(spacing: 24) {
        ProgressRingView(progress: 0)
        ProgressRingView(progress: 0.33)
        ProgressRingView(progress: 1)
    }
    .padding()
    .background(Color.pathPilotBackground)
}
