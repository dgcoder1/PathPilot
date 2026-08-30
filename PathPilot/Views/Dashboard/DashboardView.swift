//
//  DashboardView.swift
//  PathPilot — Views/Dashboard/
//
//  WHAT: Hero screen — greeting, goal + ring, next step, overview tiles, recent items.
//  WHY:  Central hub tying together all trackers; taps jump to the matching tab.
//  CONNECTS TO: DashboardViewModel, ProgressRingView, CareerCard, MainTab.
//  EDIT WHEN: Changing dashboard layout, tab deep-links, or overview count rules.
//
//  PATTERN: @Query fetches live SwiftData → syncToken triggers viewModel.update(...).
//

import SwiftData
import SwiftUI

struct DashboardView: View {

    @Query private var profiles: [UserProfile]
    @Query private var goals: [CareerGoal]
    @Query private var milestones: [Milestone]
    @Query private var skills: [Skill]
    @Query private var certifications: [Certification]
    @Query private var applications: [JobApplication]

    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTab: MainTab
    @State private var viewModel = DashboardViewModel()

    init(selectedTab: Binding<MainTab> = .constant(.dashboard)) {
        _selectedTab = selectedTab
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                headerSection
                CareerCard(
                    title: "Your Goal",
                    value: viewModel.targetRole,
                    progress: viewModel.progress,
                    encouragement: viewModel.encouragementMessage,
                    onView: { selectedTab = .profile }
                )
                nextStepSection
                overviewSection
                recentlyUpdatedSection
            }
            .padding()
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.pathPilotBackground)
        .task(id: syncToken) {
            syncViewModel()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Dashboard")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(Color.pathPilotPrimary)

                Text("\(viewModel.welcomeMessage) 👋")
                    .font(.title3)
                    .foregroundStyle(Color.pathPilotPrimary.opacity(0.7))
            }

            Spacer(minLength: 8)

            Button {
                selectedTab = .profile
            } label: {
                Text(viewModel.userInitials)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.pathPilotPrimary)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(Color.pathPilotPrimary.opacity(0.12)))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Profile, \(viewModel.userName)")
        }
    }

    // MARK: - Next step (milestone toggle + jump to Certs)

    private var nextStepSection: some View {
        Group {
            if let milestone = viewModel.nextMilestone {
                HStack(spacing: 12) {
                    Button {
                        toggleMilestone(milestone)
                    } label: {
                        Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "list.clipboard.fill")
                            .font(.title3)
                            .foregroundStyle(Color.pathPilotAccent)
                            .frame(width: 44, height: 44)
                            .background(Color.pathPilotAccent.opacity(0.14))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(milestone.isCompleted ? "Mark incomplete" : "Mark complete")

                    Button {
                        selectedTab = .certifications
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("NEXT STEP")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.pathPilotAccent)
                                .tracking(0.5)

                            Text(milestone.title)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(Color.pathPilotPrimary)
                                .multilineTextAlignment(.leading)

                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                Text("No due date")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Opens Certifications")

                    Button {
                        selectedTab = .certifications
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 28, height: 28)
                            .background(Color.pathPilotBackground)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Open Certifications")
                }
                .padding(14)
                .background(Color.pathPilotCard)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
            } else {
                Text("No milestones yet. Add one to track your next career step.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.pathPilotCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Overview tiles

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Overview")
                    .font(.headline)
                    .foregroundStyle(Color.pathPilotPrimary)

                Spacer()

                Button {
                    selectedTab = .skills
                } label: {
                    HStack(spacing: 2) {
                        Text("See all")
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.pathPilotPrimary)
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 10) {
                overviewTile(
                    title: "Skills",
                    count: viewModel.skillsCount,
                    caption: "Tracking",
                    systemImage: "brain.head.profile",
                    tint: Color.pathPilotAccent,
                    tab: .skills
                )
                overviewTile(
                    title: "Certifications",
                    count: viewModel.certificationsCount,
                    caption: "Earned",
                    systemImage: "rosette",
                    tint: Color.pathPilotPrimary,
                    tab: .certifications
                )
                overviewTile(
                    title: "Applications",
                    count: viewModel.applicationsCount,
                    caption: "In Progress",
                    systemImage: "briefcase.fill",
                    tint: .purple,
                    tab: .applications
                )
            }
        }
    }

    private func overviewTile(
        title: String,
        count: Int,
        caption: String,
        systemImage: String,
        tint: Color,
        tab: MainTab
    ) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: systemImage)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(tint)
                    .frame(width: 32, height: 32)
                    .background(tint.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text("\(count)")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.pathPilotPrimary)

                Text(caption)
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Sparkline(color: tint)
                    .frame(height: 18)
                    .padding(.top, 2)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.pathPilotCard)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title), \(count) \(caption)")
        .accessibilityHint("Opens \(title)")
    }

    // MARK: - Recently updated

    private var recentlyUpdatedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Updated")
                .font(.headline)
                .foregroundStyle(Color.pathPilotPrimary)

            if viewModel.recentItems.isEmpty {
                Text("Updates will show here as you add skills, certs, and applications.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.recentItems) { item in
                    Button {
                        selectedTab = tab(for: item.kind)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: icon(for: item.kind))
                                .font(.body)
                                .foregroundStyle(Color.pathPilotAccent)
                                .frame(width: 36, height: 36)
                                .background(Color.pathPilotAccent.opacity(0.14))
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(Color.pathPilotPrimary)
                                    .multilineTextAlignment(.leading)

                                Text(item.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer(minLength: 8)

                            Text(item.relativeDateText)
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .padding(12)
                        .background(Color.pathPilotCard)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func tab(for kind: RecentActivityItem.Kind) -> MainTab {
        switch kind {
        case .skill: .skills
        case .certification: .certifications
        case .application: .applications
        }
    }

    private func icon(for kind: RecentActivityItem.Kind) -> String {
        switch kind {
        case .skill: "brain.head.profile"
        case .certification: "list.clipboard.fill"
        case .application: "briefcase.fill"
        }
    }

    // MARK: - Actions / sync

    private func toggleMilestone(_ milestone: Milestone) {
        let markingComplete = !milestone.isCompleted

        withAnimation(.easeInOut(duration: 0.3)) {
            milestone.isCompleted.toggle()
        }

        if markingComplete {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        try? modelContext.save()
    }

    private var syncToken: String {
        let milestoneCompleted = milestones.filter(\.isCompleted).count
        let skillsCompleted = skills.filter { $0.status == .completed }.count
        let certsCompleted = certifications.filter { $0.status == .completed }.count
        let applicationsSubmitted = applications.filter { $0.status != .saved }.count
        return """
        \(profiles.first?.name ?? "")|\(activeGoal?.targetRole ?? "")|\
        \(milestones.count)|\(milestoneCompleted)|\
        \(skills.count)|\(skillsCompleted)|\
        \(certifications.count)|\(certsCompleted)|\
        \(applications.count)|\(applicationsSubmitted)
        """
    }

    private var activeGoal: CareerGoal? {
        goals.first(where: \.isActive) ?? goals.first
    }

    private func syncViewModel() {
        viewModel.update(
            profile: profiles.first,
            goal: activeGoal,
            milestones: milestones,
            skills: skills,
            certifications: certifications,
            applications: applications
        )
    }
}

// MARK: - Decorative sparkline (not real history)

private struct Sparkline: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let points: [CGFloat] = [0.35, 0.5, 0.4, 0.68, 0.55, 0.85]
            let step = geo.size.width / CGFloat(max(points.count - 1, 1))

            Path { path in
                for (index, value) in points.enumerated() {
                    let x = step * CGFloat(index)
                    let y = geo.size.height * (1 - value)
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
        }
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
            Certification.self, JobApplication.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext

        context.insert(UserProfile(name: "Jordan", currentBackground: "Psychology graduate"))
        context.insert(CareerGoal(targetRole: "Cloud Security Analyst"))
        context.insert(Milestone(title: "Complete AWS Cloud Practitioner", sortOrder: 0))
        context.insert(Skill(name: "Python", category: .current, status: .completed))
        context.insert(Skill(name: "SQL", category: .current, status: .completed))
        context.insert(Skill(name: "AWS", category: .toLearn, status: .notStarted))
        context.insert(Certification(name: "AWS Cloud Practitioner", status: .inProgress))
        context.insert(JobApplication(company: "Acme Corp", roleTitle: "Cloud Security Analyst", status: .applied, appliedDate: .now))
        context.insert(JobApplication(company: "Globex", roleTitle: "SOC Analyst", status: .saved))
        context.insert(JobApplication(company: "Initech", roleTitle: "Security Engineer", status: .interview))

        return container
    }
}
