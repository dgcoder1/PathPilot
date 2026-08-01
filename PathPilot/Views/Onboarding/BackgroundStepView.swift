//
//  BackgroundStepView.swift
//  PathPilot
//
//  Onboarding Step 1 — name and current professional background.
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
                    placeholder: "Alex",
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
