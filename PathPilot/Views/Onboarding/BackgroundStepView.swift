//
//  BackgroundStepView.swift
//  PathPilot — Views/Onboarding/
//
//  WHAT: Onboarding Step 1 — collects name and current professional background.
//  WHY:  Personalizes dashboard greeting and profile tab.
//  CONNECTS TO: OnboardingViewModel.name, .currentBackground via @Bindable.
//  EDIT WHEN: Adding fields (location, years of experience) or changing validation.
//

import SwiftUI

struct BackgroundStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingStepHeader(
                title: "Tell us about you",
                subtitle: "We'll personalize your roadmap from where you are today."
            )

            VStack(spacing: 16) {
                OnboardingTextField(
                    title: "Your name",
                    placeholder: "Enter your name",
                    text: $viewModel.name
                )
                .textContentType(.name)
                .autocorrectionDisabled()

                OnboardingTextField(
                    title: "Current background",
                    placeholder: "Psychology graduate, retail manager…",
                    text: $viewModel.currentBackground,
                    axis: .vertical
                )
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    BackgroundStepView(viewModel: OnboardingViewModel())
        .background(Color.pathPilotBackground)
}
