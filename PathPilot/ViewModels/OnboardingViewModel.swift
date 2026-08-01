//
//  OnboardingViewModel.swift
//  PathPilot
//
//  Holds onboarding form state, step navigation, and validation.
//  Views bind to this @Observable type; persistence runs on completeOnboarding.
//

import Foundation
import Observation
import SwiftData

@Observable
final class OnboardingViewModel {

    // MARK: - Steps

    /// Current wizard step (0 = Welcome … 4 = Milestone).
    var currentStep = 0

    /// Total number of steps in the onboarding flow.
    static let totalSteps = 5

    // MARK: - Form fields

    var name = ""
    var currentBackground = ""
    var targetRole = ""
    /// Comma-separated list, e.g. "Python, SQL"
    var currentSkills = ""
    /// Comma-separated list, e.g. "AWS, Terraform"
    var skillsToLearn = ""
    var firstMilestone = ""

    // MARK: - Navigation

    /// Whether the user can advance from the current step.
    var canProceed: Bool {
        switch currentStep {
        case 0:
            return true
        case 1:
            return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && !currentBackground.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 2:
            return !targetRole.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 3:
            // Skills are optional in V1 — user can skip and add them later.
            return true
        case 4:
            return !firstMilestone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        default:
            return false
        }
    }

    var canGoBack: Bool {
        currentStep > 0
    }

    var isLastStep: Bool {
        currentStep == Self.totalSteps - 1
    }

    func nextStep() {
        guard canProceed, currentStep < Self.totalSteps - 1 else { return }
        currentStep += 1
    }

    func previousStep() {
        guard canGoBack else { return }
        currentStep -= 1
    }

    // MARK: - Persistence

    /// Saves onboarding answers to SwiftData. Call from the finish button;
    /// the view layer sets `@AppStorage("hasCompletedOnboarding")` after success.
    func completeOnboarding(context: ModelContext) throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBackground = currentBackground.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedRole = targetRole.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMilestone = firstMilestone.trimmingCharacters(in: .whitespacesAndNewlines)

        let profile = UserProfile(
            name: trimmedName,
            currentBackground: trimmedBackground,
            hasCompletedOnboarding: true
        )
        context.insert(profile)

        let goal = CareerGoal(targetRole: trimmedRole)
        context.insert(goal)

        for skill in parseSkills(
            from: currentSkills,
            category: .current,
            status: .completed
        ) {
            context.insert(skill)
        }

        for skill in parseSkills(
            from: skillsToLearn,
            category: .toLearn,
            status: .notStarted
        ) {
            context.insert(skill)
        }

        let milestone = Milestone(title: trimmedMilestone, sortOrder: 0)
        context.insert(milestone)

        try context.save()
    }

    // MARK: - Helpers

    private func parseSkills(
        from text: String,
        category: SkillCategory,
        status: SkillStatus
    ) -> [Skill] {
        text.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { Skill(name: $0, category: category, status: status) }
    }
}
