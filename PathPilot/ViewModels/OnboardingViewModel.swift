//
//  OnboardingViewModel.swift
//  PathPilot — ViewModels/
//
//  WHAT: Manages onboarding wizard state — form fields, step navigation, validation, save.
//  WHY:  Five step views share one ViewModel; keeps navigation logic out of each step view.
//        @Observable lets step views use @Bindable for two-way field binding.
//  CONNECTS TO: OnboardingContainerView + 5 step views; writes to SwiftData on finish.
//  EDIT WHEN: Adding/removing steps, changing validation rules, or onboarding fields.
//

import Foundation
import Observation
import SwiftData

@Observable
final class OnboardingViewModel {

    // MARK: - Steps

    /// Current wizard step (0 = Welcome … 4 = Milestone).
    var currentStep = 0

    static let totalSteps = 5

    // MARK: - Form fields

    var name = ""
    var currentBackground = ""
    var targetRole = ""
    /// Comma-separated, e.g. "Python, SQL" — parsed into Skill rows on finish.
    var currentSkills = ""
    var skillsToLearn = ""
    var firstMilestone = ""

    // MARK: - Navigation

    /// Gates the Next/Finish button — each step has different required fields.
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
            return true   // Skills optional in V1
        case 4:
            return !firstMilestone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        default:
            return false
        }
    }

    var canGoBack: Bool { currentStep > 0 }
    var isLastStep: Bool { currentStep == Self.totalSteps - 1 }

    func nextStep() {
        guard canProceed, currentStep < Self.totalSteps - 1 else { return }
        currentStep += 1
    }

    func previousStep() {
        guard canGoBack else { return }
        currentStep -= 1
    }

    // MARK: - Persistence

    /// Inserts UserProfile, CareerGoal, Skills, and Milestone into SwiftData.
    /// OnboardingContainerView sets @AppStorage after this succeeds.
    func completeOnboarding(context: ModelContext) throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBackground = currentBackground.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedRole = targetRole.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMilestone = firstMilestone.trimmingCharacters(in: .whitespacesAndNewlines)

        context.insert(UserProfile(
            name: trimmedName,
            currentBackground: trimmedBackground,
            hasCompletedOnboarding: true
        ))

        context.insert(CareerGoal(targetRole: trimmedRole))

        for skill in parseSkills(from: currentSkills, category: .current, status: .completed) {
            context.insert(skill)
        }

        for skill in parseSkills(from: skillsToLearn, category: .toLearn, status: .notStarted) {
            context.insert(skill)
        }

        context.insert(Milestone(title: trimmedMilestone, sortOrder: 0))

        try context.save()
    }

    // MARK: - Helpers

    /// Splits "Python, SQL, AWS" into individual Skill objects.
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
