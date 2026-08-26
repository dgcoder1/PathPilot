//
//  ProfileView.swift
//  PathPilot — Views/Profile/
//
//  WHAT: Profile tab — read-only name, background, target role, plus Reset Onboarding.
//  WHY:  Lets the user confirm onboarding data; reset is a testing shortcut back to the wizard.
//  CONNECTS TO: UserProfile + CareerGoal (@Query), RootView (@AppStorage gate).
//  EDIT WHEN: Adding profile edit sheets (V2) or changing reset/wipe behavior.
//

import SwiftData
import SwiftUI

struct ProfileView: View {

    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @Query private var profiles: [UserProfile]
    @Query private var goals: [CareerGoal]

    @State private var isShowingResetAlert = false

    private var profile: UserProfile? { profiles.first }
    private var activeGoal: CareerGoal? { goals.first(where: \.isActive) ?? goals.first }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    detailRow(title: "Name", value: displayValue(profile?.name))
                    detailRow(title: "Background", value: displayValue(profile?.currentBackground))
                    detailRow(title: "Target role", value: displayValue(activeGoal?.targetRole))
                } header: {
                    Text("About you")
                }

                Section {
                    Button("Reset Onboarding", role: .destructive) {
                        isShowingResetAlert = true
                    }
                } footer: {
                    Text("Testing only. Clears local data and restarts onboarding.")
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.pathPilotBackground)
            .navigationTitle("Profile")
            .alert("Reset Onboarding?", isPresented: $isShowingResetAlert) {
                Button("Reset", role: .destructive) { resetOnboarding() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You'll go through onboarding again. Skills, certs, applications, and profile data on this device will be deleted.")
            }
        }
    }

    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body.weight(.medium))
                .foregroundStyle(Color.pathPilotPrimary)
        }
        .padding(.vertical, 4)
    }

    private func displayValue(_ value: String?) -> String {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? "—" : trimmed
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    /// Flips the launch gate and wipes SwiftData so a second onboarding doesn't duplicate rows.
    private func resetOnboarding() {
        do {
            try deleteAll(UserProfile.self)
            try deleteAll(CareerGoal.self)
            try deleteAll(Milestone.self)
            try deleteAll(Skill.self)
            try deleteAll(Certification.self)
            try deleteAll(JobApplication.self)
            try modelContext.save()
            hasCompletedOnboarding = false
        } catch {
            assertionFailure("Onboarding reset failed: \(error.localizedDescription)")
        }
    }

    private func deleteAll<T: PersistentModel>(_ type: T.Type) throws {
        let items = try modelContext.fetch(FetchDescriptor<T>())
        for item in items {
            modelContext.delete(item)
        }
    }
}

// MARK: - Preview

#Preview("With Profile") {
    ProfileView().modelContainer(previewContainer)
}

#Preview("Empty") {
    ProfileView().modelContainer(emptyPreviewContainer)
}

private var emptyPreviewContainer: ModelContainer {
    try! ModelContainer(
        for: UserProfile.self, CareerGoal.self, Milestone.self,
        Skill.self, Certification.self, JobApplication.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
}

private var previewContainer: ModelContainer {
    let container = try! ModelContainer(
        for: UserProfile.self, CareerGoal.self, Milestone.self,
        Skill.self, Certification.self, JobApplication.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    context.insert(UserProfile(name: "Alex", currentBackground: "Psychology graduate"))
    context.insert(CareerGoal(targetRole: "Cloud Security Analyst"))
    return container
}
