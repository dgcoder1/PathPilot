//
//  OnboardingContainerView.swift
//  PathPilot
//
//  Hosts the 5-step onboarding wizard: progress indicator, step content,
//  and Back / Next (or Finish) navigation.
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
                .animation(.easeInOut, value: viewModel.currentStep)

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

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.currentStep {
        case 0:
            WelcomeView()
        case 1:
            BackgroundStepView(viewModel: viewModel)
        case 2:
            GoalStepView(viewModel: viewModel)
        case 3:
            SkillsStepView(viewModel: viewModel)
        case 4:
            MilestoneStepView(viewModel: viewModel)
        default:
            WelcomeView()
        }
    }

    // MARK: - Progress

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
        }
    }

    // MARK: - Navigation

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
        if viewModel.isLastStep {
            return "Finish"
        }
        if viewModel.currentStep == 0 {
            return "Get Started"
        }
        return "Next"
    }

    private func handlePrimaryAction() {
        if viewModel.isLastStep {
            finishOnboarding()
        } else {
            viewModel.nextStep()
        }
    }

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

// MARK: - Shared onboarding UI

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

struct OnboardingTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var axis: Axis = .horizontal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.pathPilotPrimary)

            TextField(placeholder, text: $text, axis: axis)
                .padding(12)
                .background(Color.pathPilotCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
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
