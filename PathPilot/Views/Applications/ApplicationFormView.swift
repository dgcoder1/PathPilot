//
//  ApplicationFormView.swift
//  PathPilot — Views/Applications/
//
//  WHAT: Modal sheet for adding or editing a job application.
//  WHY:  Captures company, role title, and pipeline status in one shared form.
//  CONNECTS TO: ApplicationsListView presents this as a .sheet (add in Task 4; edit in Task 6).
//  EDIT WHEN: Adding appliedDate, notes, or changing default-status logic.
//

import SwiftData
import SwiftUI

struct ApplicationFormView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    /// nil = add a new application; non-nil = edit an existing one.
    var application: JobApplication?

    @State private var company: String
    @State private var roleTitle: String
    @State private var status: ApplicationStatus

    init(application: JobApplication? = nil) {
        self.application = application
        _company = State(initialValue: application?.company ?? "")
        _roleTitle = State(initialValue: application?.roleTitle ?? "")
        _status = State(initialValue: application?.status ?? .saved)
    }

    private var isEditing: Bool { application != nil }

    private var trimmedCompany: String {
        company.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedRoleTitle: String {
        roleTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedCompany.isEmpty && !trimmedRoleTitle.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Company", text: $company)
                        .textInputAutocapitalization(.words)

                    TextField("Role title", text: $roleTitle)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text("Job")
                }

                Section {
                    Picker("Status", selection: $status) {
                        ForEach(ApplicationStatus.allCases, id: \.self) { option in
                            Text(statusTitle(for: option)).tag(option)
                        }
                    }
                } header: {
                    Text("Pipeline")
                }
            }
            .navigationTitle(isEditing ? "Edit Application" : "Add Application")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }.disabled(!canSave)
                }
            }
        }
    }

    private func statusTitle(for status: ApplicationStatus) -> String {
        switch status {
        case .saved: "Saved"
        case .applied: "Applied"
        case .interview: "Interview"
        case .offer: "Offer"
        case .rejected: "Rejected"
        }
    }

    private func save() {
        guard canSave else { return }

        if let application {
            application.company = trimmedCompany
            application.roleTitle = trimmedRoleTitle
            application.status = status
        } else {
            let newApplication = JobApplication(
                company: trimmedCompany,
                roleTitle: trimmedRoleTitle,
                status: status
            )
            modelContext.insert(newApplication)
        }

        do {
            try modelContext.save()
            dismiss()
        } catch {
            assertionFailure("Application save failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview

#Preview("Add") {
    ApplicationFormView()
        .modelContainer(for: JobApplication.self, inMemory: true)
}

#Preview("Edit") {
    let application = JobApplication(
        company: "Acme Corp",
        roleTitle: "Cloud Security Analyst",
        status: .interview
    )
    return ApplicationFormView(application: application)
        .modelContainer(for: JobApplication.self, inMemory: true)
}
