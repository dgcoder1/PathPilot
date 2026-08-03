//
//  ProgressRingView.swift
//  PathPilot
//
//  Circular progress indicator for the dashboard hero section.
//  Accepts a 0.0–1.0 fraction; displays whole-number percent in the center.
//

import SwiftUI

struct ProgressRingView: View {

    /// Completion fraction from 0.0 (empty) to 1.0 (full ring).
    let progress: Double
    var lineWidth: CGFloat = 12
    var size: CGFloat = 140

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 1)
                .stroke(
                    Color.pathPilotPrimary.opacity(0.15),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

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
