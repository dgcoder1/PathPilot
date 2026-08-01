//
//  GoalStepView.swift
//  PathPilot
//
//  Onboarding Step 2 — target career role.
//

import SwiftUI

struct GoalStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingStepHeader(
                title: "What's your goal?",
                subtitle: "Pick the role you're working toward."
            )

            OnboardingTextField(
                title: "Target role",
                placeholder: "Cloud Security Analyst",
                text: $viewModel.targetRole
            )
            .textContentType(.jobTitle)
            .autocorrectionDisabled()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    GoalStepView(viewModel: OnboardingViewModel())
        .background(Color.pathPilotBackground)
}
