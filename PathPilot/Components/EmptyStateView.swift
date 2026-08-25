//
//  EmptyStateView.swift
//  PathPilot — Components/
//
//  WHAT: Friendly placeholder when a list has zero items.
//  WHY:  Empty lists feel broken without guidance — this explains what to do next.
//  CONNECTS TO: SkillsListView, CertificationsListView, ApplicationsListView.
//  EDIT WHEN: Changing empty-state copy or adding new list screens.
//

import SwiftUI

struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String
    var buttonTitle: String?
    var buttonAction: (() -> Void)?

    init(
        systemImage: String,
        title: String,
        message: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(Color.pathPilotPrimary)

            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.pathPilotPrimary)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Optional CTA — e.g. "Add Skill" opens the add sheet.
            if let buttonTitle, let buttonAction {
                Button(buttonTitle, action: buttonAction)
                    .buttonStyle(.borderedProminent)
                    .tint(.pathPilotAccent)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("With Button") {
    EmptyStateView(
        systemImage: "brain.head.profile",
        title: "No skills yet",
        message: "Add your first skill to start tracking progress.",
        buttonTitle: "Add Skill",
        buttonAction: {}
    )
    .background(Color.pathPilotBackground)
}

#Preview("Without Button") {
    EmptyStateView(
        systemImage: "briefcase",
        title: "No applications yet",
        message: "When you start applying, track your pipeline here."
    )
    .background(Color.pathPilotBackground)
}
