//
//  SkillFormView.swift
//  PathPilot — Views/Skills/
//
//  WHAT: Modal sheet for adding or editing a single skill.
//  WHY:  One form handles both modes — nil skill = add, non-nil = edit (shared pattern).
//  CONNECTS TO: SkillsListView presents this as a .sheet.
//  EDIT WHEN: Adding fields (notes, proficiency level) or changing default status logic.
//

import SwiftData
import SwiftUI

struct SkillFormView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let category: SkillCategory
    var skill: Skill?

    @State private var name: String

    init(category: SkillCategory, skill: Skill? = nil) {
        self.category = category
        self.skill = skill
        _name = State(initialValue: skill?.name ?? "")
    }

    private var isEditing: Bool { skill != nil }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool { !trimmedName.isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Skill name", text: $name)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text(isEditing ? "Skill" : categorySectionTitle)
                }
            }
            .navigationTitle(isEditing ? "Edit Skill" : "Add Skill")
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

    private var categorySectionTitle: String {
        switch category {
        case .current: "Current skill"
        case .toLearn: "Skill to learn"
        }
    }

    private func save() {
        guard canSave else { return }

        if let skill {
            skill.name = trimmedName
        } else {
            // Current skills default to completed; to-learn default to not started.
            let defaultStatus: SkillStatus = category == .current ? .completed : .notStarted
            modelContext.insert(Skill(name: trimmedName, category: category, status: defaultStatus))
        }

        do {
            try modelContext.save()
            dismiss()
        } catch {
            assertionFailure("Skill save failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview

#Preview("Add") {
    SkillFormView(category: .current)
        .modelContainer(for: Skill.self, inMemory: true)
}

#Preview("Edit") {
    let skill = Skill(name: "Python", category: .current, status: .completed)
    return SkillFormView(category: .current, skill: skill)
        .modelContainer(for: Skill.self, inMemory: true)
}
