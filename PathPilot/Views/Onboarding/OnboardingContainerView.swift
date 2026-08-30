//
//  OnboardingContainerView.swift
//  PathPilot — Views/Onboarding/
//
//  WHAT: Shell for the 5-step onboarding wizard — progress bar, steps, navigation.
//  WHY:  One container owns step switching and finish logic; step views stay simple.
//  CONNECTS TO: OnboardingViewModel, 5 step views, RootView (shown when onboarding incomplete).
//  EDIT WHEN: Adding/removing steps, changing navigation, or onboarding field focus.
//

import SwiftData
import SwiftUI

struct OnboardingContainerView: View {

    @State private var viewModel = OnboardingViewModel()
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @State private var showSaveError = false
    @State private var saveErrorMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            progressHeader
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 8)

            stepContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            navigationBar
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
        }
        .background(Color.pathPilotBackground)
        .alert("Couldn't save your profile", isPresented: $showSaveError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveErrorMessage)
        }
    }

    // MARK: - Step routing

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.currentStep {
        case 0: WelcomeView()
        case 1: BackgroundStepView(viewModel: viewModel)
        case 2: GoalStepView(viewModel: viewModel)
        case 3: SkillsStepView(viewModel: viewModel)
        case 4: MilestoneStepView(viewModel: viewModel)
        default: WelcomeView()
        }
    }

    // MARK: - Progress indicator

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step \(viewModel.currentStep + 1) of \(OnboardingViewModel.totalSteps)")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

            ProgressView(
                value: Double(viewModel.currentStep + 1),
                total: Double(OnboardingViewModel.totalSteps)
            )
            .tint(.pathPilotAccent)
            .animation(.easeInOut, value: viewModel.currentStep)
        }
    }

    // MARK: - Back / Next / Finish buttons

    private var navigationBar: some View {
        HStack(spacing: 12) {
            if viewModel.canGoBack {
                Button("Back", action: viewModel.previousStep)
                    .buttonStyle(.bordered)
                    .tint(.pathPilotPrimary)
            }

            Spacer()

            Button(primaryButtonTitle, action: handlePrimaryAction)
                .buttonStyle(.borderedProminent)
                .tint(.pathPilotAccent)
                .disabled(!viewModel.canProceed)
        }
    }

    private var primaryButtonTitle: String {
        if viewModel.isLastStep { return "Finish" }
        if viewModel.currentStep == 0 { return "Get Started" }
        return "Next"
    }

    private func handlePrimaryAction() {
        if viewModel.isLastStep {
            finishOnboarding()
        } else {
            viewModel.nextStep()
        }
    }

    /// Saves to SwiftData, then flips @AppStorage so RootView shows MainTabView.
    private func finishOnboarding() {
        do {
            try viewModel.completeOnboarding(context: modelContext)
            hasCompletedOnboarding = true
        } catch {
            saveErrorMessage = error.localizedDescription
            showSaveError = true
        }
    }
}

// MARK: - Shared onboarding UI (used by step views)

/// Title + subtitle block at the top of form steps.
struct OnboardingStepHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.pathPilotPrimary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

/// Styled text field used across onboarding form steps.
struct OnboardingTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var axis: Axis = .horizontal
    var textContentType: UITextContentType?
    /// Become first responder when the step appears — avoids multi-tap after a transition.
    var focusOnAppear: Bool = false

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.pathPilotPrimary)
                .onTapGesture { isFocused = true }

            TextField(placeholder, text: $text, axis: axis)
                .focused($isFocused)
                .textContentType(textContentType)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .padding(12)
                .background(Color.pathPilotCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                // Padding + clipShape shrink the default hit box; this matches the visible card.
                .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        // Implicit step animation on a parent used to eat the first tap. Keep fields still.
        .transaction { $0.animation = nil }
        .onAppear {
            guard focusOnAppear else { return }
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(150))
                isFocused = true
            }
        }
    }
}

#Preview {
    OnboardingContainerView()
        .modelContainer(for: [
            UserProfile.self,
            CareerGoal.self,
            Milestone.self,
            Skill.self,
        ], inMemory: true)
}
