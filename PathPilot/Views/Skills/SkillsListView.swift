//
//  SkillsListView.swift
//  PathPilot
//
//  Skills tracker — segmented Current / To Learn list (Day 4).
//

import SwiftData
import SwiftUI

struct SkillsListView: View {

    @State private var selectedCategory: SkillCategory = .current

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

                SkillsSegmentList(category: selectedCategory)
            }
            .background(Color.pathPilotBackground)
            .navigationTitle("Skills")
        }
    }
}

// MARK: - Filtered list

/// Separate view so `@Query` re-initializes when the segment changes.
private struct SkillsSegmentList: View {

    let category: SkillCategory

    @Query private var skills: [Skill]

    init(category: SkillCategory) {
        self.category = category
        _skills = Query(
            filter: #Predicate<Skill> { skill in
                skill.category == category
            },
            sort: \Skill.createdAt
        )
    }

    var body: some View {
        List {
            ForEach(skills) { skill in
                SkillRowView(skill: skill)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
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
