//
//  SkillsListView.swift
//  PathPilot
//
//  Placeholder for the skills tracker (implemented on Day 4).
//

import SwiftUI

struct SkillsListView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.largeTitle)
                    .foregroundStyle(Color.pathPilotPrimary)

                Text("Coming soon")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pathPilotBackground)
            .navigationTitle("Skills")
        }
    }
}

#Preview {
    SkillsListView()
}
