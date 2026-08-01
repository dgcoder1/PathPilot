//
//  SkillsStepView.swift
//  PathPilot
//
//  Onboarding Step 3 — current skills and skills to learn (comma-separated).
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
                    axis: .vertical
                )
                .autocorrectionDisabled()

                OnboardingTextField(
                    title: "Skills to learn",
                    placeholder: "AWS, Terraform, Networking",
                    text: $viewModel.skillsToLearn,
                    axis: .vertical
                )
                .autocorrectionDisabled()
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
