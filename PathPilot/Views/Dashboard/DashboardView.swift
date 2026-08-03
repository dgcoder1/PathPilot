//
//  DashboardView.swift
//  PathPilot
//
//  Career dashboard — live data from SwiftData, progress ring, milestones, quick stats.
//

import SwiftData
import SwiftUI

struct DashboardView: View {

    @Query private var profiles: [UserProfile]
    @Query private var goals: [CareerGoal]
    @Query private var milestones: [Milestone]
    @Query private var skills: [Skill]

    @State private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(viewModel.welcomeMessage)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.pathPilotPrimary)

                    CareerCard(title: "Your Goal", value: viewModel.targetRole)

                    progressSection

                    milestonesSection

                    quickStatsSection
                }
                .padding()
            }
            .background(Color.pathPilotBackground)
            .navigationTitle("Dashboard")
            .task(id: syncToken) {
                syncViewModel()
            }
        }
    }

    // MARK: - Sections

    private var progressSection: some View {
        VStack(spacing: 12) {
            Text("Your Progress")
                .font(.headline)
                .foregroundStyle(Color.pathPilotPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            ProgressRingView(progress: viewModel.progress)
                .animation(.easeInOut(duration: 0.35), value: viewModel.progress)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.pathPilotCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    private var milestonesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Next Steps")
                .font(.headline)
                .foregroundStyle(Color.pathPilotPrimary)

            if viewModel.sortedMilestones.isEmpty {
                Text("No milestones yet. Add one to track your next career step.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.pathPilotCard)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(viewModel.sortedMilestones) { milestone in
                    MilestoneChecklistRow(milestone: milestone)
                }
            }
        }
    }

    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Stats")
                .font(.headline)
                .foregroundStyle(Color.pathPilotPrimary)

            HStack(spacing: 12) {
                QuickStatCard(
                    title: "Skills",
                    count: viewModel.skillsCount,
                    systemImage: "brain.head.profile"
                )
                QuickStatCard(
                    title: "Certs",
                    count: viewModel.certificationsCount,
                    systemImage: "rosette"
                )
                QuickStatCard(
                    title: "Apps",
                    count: viewModel.applicationsCount,
                    systemImage: "briefcase"
                )
            }
        }
    }

    // MARK: - View model sync

    /// Changes when any @Query result relevant to the dashboard updates.
    private var syncToken: String {
        let completed = milestones.filter(\.isCompleted).count
        return "\(profiles.first?.name ?? "")|\(activeGoal?.targetRole ?? "")|\(milestones.count)|\(completed)|\(skills.count)"
    }

    private var activeGoal: CareerGoal? {
        goals.first(where: \.isActive) ?? goals.first
    }

    private func syncViewModel() {
        viewModel.update(
            profile: profiles.first,
            goal: activeGoal,
            milestones: milestones,
            skills: skills
        )
    }
}

// MARK: - Milestone row

private struct MilestoneChecklistRow: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var milestone: Milestone

    var body: some View {
        Button {
            toggleMilestone()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(milestone.isCompleted ? Color.pathPilotAccent : .secondary)

                Text(milestone.title)
                    .font(.body)
                    .foregroundStyle(milestone.isCompleted ? .secondary : .primary)
                    .strikethrough(milestone.isCompleted, color: .secondary)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)
            }
            .padding()
            .background(Color.pathPilotCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }

    private func toggleMilestone() {
        let markingComplete = !milestone.isCompleted

        withAnimation(.easeInOut(duration: 0.3)) {
            milestone.isCompleted.toggle()
        }

        if markingComplete {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        try? modelContext.save()
    }
}

// MARK: - Quick stat card

private struct QuickStatCard: View {
    let title: String
    let count: Int
    let systemImage: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(Color.pathPilotAccent)

            Text("\(count)")
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.pathPilotPrimary)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.pathPilotCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
    }
}

// MARK: - Preview

#Preview {
    DashboardPreviewContainer()
}

private struct DashboardPreviewContainer: View {
    var body: some View {
        DashboardView()
            .modelContainer(previewContainer)
    }

    private var previewContainer: ModelContainer {
        let container = try! ModelContainer(
            for: UserProfile.self, CareerGoal.self, Milestone.self, Skill.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext

        context.insert(UserProfile(name: "Alex", currentBackground: "Retail"))
        context.insert(CareerGoal(targetRole: "Cloud Security Analyst"))
        context.insert(Milestone(title: "Complete AWS Cloud Practitioner", sortOrder: 0))
        context.insert(Skill(name: "Python", category: .current, status: .completed))
        context.insert(Skill(name: "AWS", category: .toLearn, status: .notStarted))

        return container
    }
}
