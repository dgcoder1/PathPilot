//
//  SkillsStepView.swift
//  PathPilot — Views/Onboarding/
//
//  WHAT: Onboarding Step 3 — comma-separated current skills and skills to learn.
//  WHY:  Seeds the Skills tab so users don't start from empty after onboarding.
//  CONNECTS TO: OnboardingViewModel.currentSkills / .skillsToLearn → Skill rows on finish.
//  EDIT WHEN: Replacing comma fields with chip UI (V2) or making skills required.
//

import SwiftUI

struct SkillsStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingStepHeader(
                title: "Your skills",
                subtitle: "Separate multiple skills with commas. You can skip and add more later."
            )

            VStack(spacing: 16) {
                OnboardingTextField(
                    title: "Current skills",
                    placeholder: "Python, SQL, Communication",
                    text: $viewModel.currentSkills,
                    axis: .vertical,
                    focusOnAppear: true
                )

                OnboardingTextField(
                    title: "Skills to learn",
                    placeholder: "AWS, Terraform, Networking",
                    text: $viewModel.skillsToLearn,
                    axis: .vertical
                )
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    SkillsStepView(viewModel: OnboardingViewModel())
        .background(Color.pathPilotBackground)
}
