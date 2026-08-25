//
//  ApplicationsListView.swift
//  PathPilot — Views/Applications/
//
//  WHAT: Applications tab — list of job applications with status badges and add sheet.
//  WHY:  Tracks hiring pipeline (Saved → Applied → Interview → Offer / Rejected).
//  CONNECTS TO: ApplicationFormView, JobApplication model, StatusBadge, EmptyStateView.
//  EDIT WHEN: Adding tap-to-edit (Task 6) or empty-state CTA (Task 7).
//
//  STATUS: Task 5 — add + swipe-to-delete persist. Edit/empty CTA still pending.
//

import SwiftData
import SwiftUI

struct ApplicationsListView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var applications: [JobApplication]

    @State private var isShowingAddSheet = false

    /// @Query can't sort enums in pipeline order — we sort in-memory instead.
    private var sortedApplications: [JobApplication] {
        applications.sorted { lhs, rhs in
            let leftOrder = lhs.status.pipelineSortOrder
            let rightOrder = rhs.status.pipelineSortOrder

            if leftOrder != rightOrder {
                return leftOrder < rightOrder
            }

            let companyComparison = lhs.company.localizedCaseInsensitiveCompare(rhs.company)
            if companyComparison != .orderedSame {
                return companyComparison == .orderedAscending
            }

            return lhs.roleTitle.localizedCaseInsensitiveCompare(rhs.roleTitle) == .orderedAscending
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if sortedApplications.isEmpty {
                    emptyPlaceholder
                } else {
                    List {
                        ForEach(sortedApplications) { application in
                            ApplicationRowView(application: application)
                        }
                        .onDelete(perform: deleteApplications)
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.pathPilotBackground)
            .navigationTitle("Applications")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { isShowingAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add application")
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                ApplicationFormView()
                    .environment(\.modelContext, modelContext)
            }
        }
    }

    private var emptyPlaceholder: some View {
        EmptyStateView(
            systemImage: "briefcase",
            title: "No applications yet",
            message: "When you start applying, track your pipeline here."
        )
    }

    /// Offsets match the on-screen list (`sortedApplications`), not the unsorted `@Query`.
    private func deleteApplications(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(sortedApplications[index])
        }
        do {
            try modelContext.save()
        } catch {
            assertionFailure("Application delete failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Row

private struct ApplicationRowView: View {
    let application: JobApplication

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(application.company)
                    .font(.body.weight(.medium))
                    .foregroundStyle(
                        application.status == .rejected ? .secondary : Color.pathPilotPrimary
                    )

                Text(application.roleTitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            StatusBadge(applicationStatus: application.status)
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Sorting

private extension ApplicationStatus {
    /// Pipeline order: Saved → Applied → Interview → Offer → Rejected.
    var pipelineSortOrder: Int {
        switch self {
        case .saved: 0
        case .applied: 1
        case .interview: 2
        case .offer: 3
        case .rejected: 4
        }
    }
}

// MARK: - Preview

#Preview("With Applications") {
    ApplicationsListView().modelContainer(previewContainer)
}

#Preview("Empty") {
    ApplicationsListView().modelContainer(emptyPreviewContainer)
}

private var emptyPreviewContainer: ModelContainer {
    try! ModelContainer(
        for: JobApplication.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
}

private var previewContainer: ModelContainer {
    let container = try! ModelContainer(
        for: JobApplication.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext

    context.insert(JobApplication(company: "Acme Corp", roleTitle: "Cloud Security Analyst", status: .interview))
    context.insert(JobApplication(company: "Globex", roleTitle: "SOC Analyst II", status: .saved))
    context.insert(JobApplication(company: "Initech", roleTitle: "Security Engineer", status: .applied, appliedDate: .now))
    context.insert(JobApplication(company: "Umbrella", roleTitle: "GRC Analyst", status: .rejected))
    context.insert(JobApplication(company: "Wayne Enterprises", roleTitle: "AppSec Engineer", status: .offer))

    return container
}
