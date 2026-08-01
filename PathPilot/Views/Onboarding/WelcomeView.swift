//
//  WelcomeView.swift
//  PathPilot
//
//  Onboarding Step 0 — intro screen before collecting user details.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "map.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.pathPilotAccent)
                .accessibilityHidden(true)

            VStack(spacing: 12) {
                Text("Welcome to PathPilot")
                    .font(.title.weight(.bold))
                    .foregroundStyle(Color.pathPilotPrimary)
                    .multilineTextAlignment(.center)

                Text("Let's build your career roadmap in a few quick steps.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WelcomeView()
        .background(Color.pathPilotBackground)
}
