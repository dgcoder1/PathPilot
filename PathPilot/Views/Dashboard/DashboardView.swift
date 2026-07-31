//
//  DashboardView.swift
//  PathPilot
//
//  Placeholder for the career dashboard (implemented on Day 3).
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.largeTitle)
                    .foregroundStyle(Color.pathPilotPrimary)

                Text("Coming soon")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pathPilotBackground)
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView()
}
