//
//  CertificationFormView.swift
//  PathPilot
//
//  Shared sheet for adding and editing certifications (Day 5).
//

import SwiftData
import SwiftUI

struct CertificationFormView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var certification: Certification?

    @State private var name: String
    @State private var status: CertStatus
    @State private var hasTargetDate: Bool
    @State private var targetDate: Date

    init(certification: Certification? = nil) {
        self.certification = certification
        _name = State(initialValue: certification?.name ?? "")
        _status = State(initialValue: certification?.status ?? .planned)
        _hasTargetDate = State(initialValue: certification?.targetDate != nil)
        _targetDate = State(initialValue: certification?.targetDate ?? .now)
    }

    private var isEditing: Bool { certification != nil }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedName.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Certification name", text: $name)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text("Certification")
                }

                Section {
                    Picker("Status", selection: $status) {
                        ForEach(CertStatus.allCases, id: \.self) { option in
                            Text(statusTitle(for: option)).tag(option)
                        }
                    }

                    Toggle("Target date", isOn: $hasTargetDate.animation())

                    if hasTargetDate {
                        DatePicker(
                            "Target",
                            selection: $targetDate,
                            displayedComponents: .date
                        )
                    }
                } header: {
                    Text("Progress")
                }
            }
            .navigationTitle(isEditing ? "Edit Certification" : "Add Certification")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private func statusTitle(for status: CertStatus) -> String {
        switch status {
        case .planned:
            "Planned"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }

    private func save() {
        guard canSave else { return }

        let resolvedTargetDate = hasTargetDate ? targetDate : nil

        if let certification {
            certification.name = trimmedName
            certification.status = status
            certification.targetDate = resolvedTargetDate
            applyCompletionDate(to: certification)
        } else {
            let newCertification = Certification(
                name: trimmedName,
                status: status,
                targetDate: resolvedTargetDate
            )
            applyCompletionDate(to: newCertification)
            modelContext.insert(newCertification)
        }

        do {
            try modelContext.save()
            dismiss()
        } catch {
            assertionFailure("Certification save failed: \(error.localizedDescription)")
        }
    }

    private func applyCompletionDate(to certification: Certification) {
        if certification.status == .completed {
            if certification.completedDate == nil {
                certification.completedDate = .now
            }
        } else {
            certification.completedDate = nil
        }
    }
}

// MARK: - Preview

#Preview("Add") {
    CertificationFormView()
        .modelContainer(for: Certification.self, inMemory: true)
}

#Preview("Edit") {
    let certification = Certification(
        name: "AWS Solutions Architect",
        status: .inProgress,
        targetDate: .now
    )

    return CertificationFormView(certification: certification)
        .modelContainer(for: Certification.self, inMemory: true)
}
