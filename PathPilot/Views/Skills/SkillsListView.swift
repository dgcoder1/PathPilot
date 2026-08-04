//
//  SkillsListView.swift
//  PathPilot
//
//  Skills tracker — segmented Current / To Learn list (Day 4).
//

import SwiftData
import SwiftUI

struct SkillsListView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Skill.createdAt) private var allSkills: [Skill]

    @State private var selectedCategory: SkillCategory = .current
    @State private var isShowingAddSheet = false

    private var filteredSkills: [Skill] {
        allSkills.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Category", selection: $selectedCategory) {
                    Text("Current").tag(SkillCategory.current)
                    Text("To Learn").tag(SkillCategory.toLearn)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 12)

                List {
                    ForEach(filteredSkills) { skill in
                        SkillRowView(skill: skill)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .background(Color.pathPilotBackground)
            .navigationTitle("Skills")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add skill")
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                SkillFormView(category: selectedCategory)
                    .environment(\.modelContext, modelContext)
            }
        }
    }
}

// MARK: - Row

private struct SkillRowView: View {
    let skill: Skill

    var body: some View {
        Text(skill.name)
            .foregroundStyle(Color.pathPilotPrimary)
    }
}

// MARK: - Preview

#Preview {
    SkillsListView()
        .modelContainer(previewContainer)
}

private var previewContainer: ModelContainer {
    let container = try! ModelContainer(
        for: Skill.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext

    context.insert(Skill(name: "Python", category: .current, status: .completed))
    context.insert(Skill(name: "SQL", category: .current, status: .inProgress))
    context.insert(Skill(name: "AWS", category: .toLearn, status: .notStarted))
    context.insert(Skill(name: "Terraform", category: .toLearn, status: .notStarted))

    return container
}
