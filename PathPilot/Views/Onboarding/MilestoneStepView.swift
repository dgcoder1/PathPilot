//
//  MilestoneStepView.swift
//  PathPilot — Views/Onboarding/
//
//  WHAT: Onboarding Step 4 (final form step) — first career milestone.
//  WHY:  Seeds the dashboard checklist so progress ring has something to track.
//  CONNECTS TO: OnboardingViewModel.firstMilestone → Milestone model on finish.
//  EDIT WHEN: Allowing multiple milestones during onboarding (V2).
//

import SwiftUI

struct MilestoneStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingStepHeader(
                title: "Your first milestone",
                subtitle: "What's the next concrete step on your path?"
            )

            OnboardingTextField(
                title: "Milestone",
                placeholder: "Complete AWS Solutions Architect cert",
                text: $viewModel.firstMilestone,
                axis: .vertical
            )
            .autocorrectionDisabled()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    MilestoneStepView(viewModel: OnboardingViewModel())
        .background(Color.pathPilotBackground)
}
