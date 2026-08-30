//
//  GoalStepView.swift
//  PathPilot — Views/Onboarding/
//
//  WHAT: Onboarding Step 2 — collects target career role.
//  WHY:  Drives the dashboard goal card and overall app purpose.
//  CONNECTS TO: OnboardingViewModel.targetRole → CareerGoal model on finish.
//  EDIT WHEN: Adding role suggestions, templates, or picker UI (V2).
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
                text: $viewModel.targetRole,
                textContentType: .jobTitle,
                focusOnAppear: true
            )
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    GoalStepView(viewModel: OnboardingViewModel())
        .background(Color.pathPilotBackground)
}
