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
    @State private var editingSkill: Skill?

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

                if filteredSkills.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(filteredSkills) { skill in
                            SkillRowView(skill: skill) {
                                editingSkill = skill
                            }
                        }
                        .onDelete(perform: deleteSkills)
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
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
            .sheet(item: $editingSkill) { skill in
                SkillFormView(category: skill.category, skill: skill)
                    .environment(\.modelContext, modelContext)
            }
        }
    }

    private var emptyState: some View {
        EmptyStateView(
            systemImage: "brain.head.profile",
            title: emptyStateTitle,
            message: emptyStateMessage,
            buttonTitle: "Add Skill",
            buttonAction: { isShowingAddSheet = true }
        )
    }

    private var emptyStateTitle: String {
        switch selectedCategory {
        case .current:
            "No current skills"
        case .toLearn:
            "No skills to learn yet"
        }
    }

    private var emptyStateMessage: String {
        switch selectedCategory {
        case .current:
            "Add skills you already have to track your strengths."
        case .toLearn:
            "Add skills you're building toward your target role."
        }
    }

    private func deleteSkills(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredSkills[index])
        }

        do {
            try modelContext.save()
        } catch {
            assertionFailure("Skill delete failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Row

private struct SkillRowView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var skill: Skill
    var onEdit: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button {
                onEdit()
            } label: {
                Text(skill.name)
                    .foregroundStyle(skill.status == .completed ? .secondary : Color.pathPilotPrimary)
                    .strikethrough(skill.status == .completed, color: .secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .accessibilityHint("Opens skill editor")

            Button {
                cycleStatus()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: statusIcon)
                    Text(statusTitle)
                        .font(.caption.weight(.medium))
                }
                .foregroundStyle(statusColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(statusColor.opacity(0.12))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Status: \(statusTitle)")
            .accessibilityHint("Changes skill progress")
        }
    }

    private var statusTitle: String {
        switch skill.status {
        case .notStarted:
            "Not Started"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }

    private var statusIcon: String {
        switch skill.status {
        case .notStarted:
            "circle"
        case .inProgress:
            "clock"
        case .completed:
            "checkmark.circle.fill"
        }
    }

    private var statusColor: Color {
        switch skill.status {
        case .notStarted:
            .secondary
        case .inProgress:
            .orange
        case .completed:
            Color.pathPilotAccent
        }
    }

    private func cycleStatus() {
        let statuses = SkillStatus.allCases
        guard let currentIndex = statuses.firstIndex(of: skill.status) else { return }

        let nextStatus = statuses[(currentIndex + 1) % statuses.count]
        let markingComplete = nextStatus == .completed

        withAnimation(.easeInOut(duration: 0.2)) {
            skill.status = nextStatus
        }

        if markingComplete {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        do {
            try modelContext.save()
        } catch {
            assertionFailure("Skill status update failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview

#Preview("With Skills") {
    SkillsListView()
        .modelContainer(previewContainer)
}

#Preview("Empty Current Skills") {
    SkillsListView()
        .modelContainer(emptyPreviewContainer)
}

private var emptyPreviewContainer: ModelContainer {
    let container = try! ModelContainer(
        for: Skill.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext

    context.insert(Skill(name: "AWS", category: .toLearn, status: .notStarted))

    return container
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
