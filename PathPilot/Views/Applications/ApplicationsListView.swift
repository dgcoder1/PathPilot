//
//  ApplicationsListView.swift
//  PathPilot
//
//  Placeholder for the job application tracker (implemented on Day 6).
//

import SwiftUI

struct ApplicationsListView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Image(systemName: "briefcase")
                    .font(.largeTitle)
                    .foregroundStyle(Color.pathPilotPrimary)

                Text("Coming soon")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pathPilotBackground)
            .navigationTitle("Applications")
        }
    }
}

#Preview {
    ApplicationsListView()
}
