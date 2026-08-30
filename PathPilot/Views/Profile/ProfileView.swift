//
//  ProfileView.swift
//  PathPilot — Views/Profile/
//
//  WHAT: Profile tab — name (editable), read-only background and goal, Reset Onboarding.
//  WHY:  Lets the user confirm onboarding data and fix the display name without a full reset.
//  CONNECTS TO: UserProfile + CareerGoal (@Query), RootView (@AppStorage gate), Dashboard greeting.
//  EDIT WHEN: Adding background/goal edit sheets or changing reset/wipe behavior.
//

import SwiftData
import SwiftUI

struct ProfileView: View {

    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @Query private var profiles: [UserProfile]
    @Query private var goals: [CareerGoal]

    @State private var isShowingResetAlert = false
    @State private var isShowingNameEditor = false

    private var profile: UserProfile? { profiles.first }
    private var activeGoal: CareerGoal? { goals.first(where: \.isActive) ?? goals.first }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        isShowingNameEditor = true
                    } label: {
                        HStack {
                            detailRow(title: "Name", value: displayValue(profile?.name))
                            Spacer(minLength: 8)
                            Text("Edit")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color.pathPilotAccent)
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(profile == nil)
                    .accessibilityHint("Opens name editor")

                    detailRow(title: "Background", value: displayValue(profile?.currentBackground))
                    detailRow(title: "Target role", value: displayValue(activeGoal?.targetRole))
                } header: {
                    Text("About you")
                } footer: {
                    Text("Tap Edit to change the name shown on the dashboard.")
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
            .sheet(isPresented: $isShowingNameEditor) {
                if let profile {
                    NameEditView(profile: profile)
                        .environment(\.modelContext, modelContext)
                }
            }
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

// MARK: - Name editor (nil-safe: only presented when a profile exists)

private struct NameEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var profile: UserProfile
    @State private var name: String

    init(profile: UserProfile) {
        self.profile = profile
        _name = State(initialValue: profile.name)
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool { !trimmedName.isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Your name", text: $name)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                } header: {
                    Text("Name")
                } footer: {
                    Text("This updates the dashboard greeting and profile.")
                }
            }
            .navigationTitle("Edit Name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!canSave)
                }
            }
        }
    }

    private func save() {
        guard canSave else { return }
        profile.name = trimmedName
        do {
            try modelContext.save()
            dismiss()
        } catch {
            assertionFailure("Name save failed: \(error.localizedDescription)")
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
