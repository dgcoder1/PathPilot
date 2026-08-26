//
//  ApplicationFormView.swift
//  PathPilot — Views/Applications/
//
//  WHAT: Modal sheet for adding or editing a job application.
//  WHY:  Captures company, role title, pipeline status; sets appliedDate once Applied+.
//  CONNECTS TO: ApplicationsListView presents this as a .sheet (nil = add, non-nil = edit).
//  EDIT WHEN: Adding notes or changing applied-date default logic.
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
    @State private var appliedDate: Date

    init(application: JobApplication? = nil) {
        self.application = application
        _company = State(initialValue: application?.company ?? "")
        _roleTitle = State(initialValue: application?.roleTitle ?? "")
        _status = State(initialValue: application?.status ?? .saved)
        _appliedDate = State(initialValue: application?.appliedDate ?? .now)
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

                    if status != .saved {
                        DatePicker("Applied", selection: $appliedDate, displayedComponents: .date)
                    }
                } header: {
                    Text("Pipeline")
                }
            }
            .onChange(of: status) { oldStatus, newStatus in
                // First move into Applied+ defaults the date to today; later moves keep it.
                if oldStatus == .saved && newStatus != .saved && application?.appliedDate == nil {
                    appliedDate = .now
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
            applyAppliedDate(to: application)
        } else {
            let newApplication = JobApplication(
                company: trimmedCompany,
                roleTitle: trimmedRoleTitle,
                status: status
            )
            applyAppliedDate(to: newApplication)
            modelContext.insert(newApplication)
        }

        do {
            try modelContext.save()
            dismiss()
        } catch {
            assertionFailure("Application save failed: \(error.localizedDescription)")
        }
    }

    /// Saved → no date. Applied+ → keep an existing date, otherwise use the picker (defaults to today).
    private func applyAppliedDate(to application: JobApplication) {
        if status == .saved {
            application.appliedDate = nil
        } else {
            application.appliedDate = appliedDate
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
