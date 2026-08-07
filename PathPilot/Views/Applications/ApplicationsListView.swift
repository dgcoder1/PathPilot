//
//  ApplicationsListView.swift
//  PathPilot
//
//  Day 6 job application tracker — read-only list with status badges (Task 3).
//

import SwiftData
import SwiftUI

struct ApplicationsListView: View {

    @Query private var applications: [JobApplication]

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
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.pathPilotBackground)
            .navigationTitle("Applications")
        }
    }

    private var emptyPlaceholder: some View {
        EmptyStateView(
            systemImage: "briefcase",
            title: "No applications yet",
            message: "When you start applying, track your pipeline here."
        )
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
    /// Pipeline order for list sorting: Saved → Applied → Interview → Offer → Rejected.
    var pipelineSortOrder: Int {
        switch self {
        case .saved:
            0
        case .applied:
            1
        case .interview:
            2
        case .offer:
            3
        case .rejected:
            4
        }
    }
}

// MARK: - Preview

#Preview("With Applications") {
    ApplicationsListView()
        .modelContainer(previewContainer)
}

#Preview("Empty") {
    ApplicationsListView()
        .modelContainer(emptyPreviewContainer)
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

    context.insert(
        JobApplication(company: "Acme Corp", roleTitle: "Cloud Security Analyst", status: .interview)
    )
    context.insert(
        JobApplication(company: "Globex", roleTitle: "SOC Analyst II", status: .saved)
    )
    context.insert(
        JobApplication(
            company: "Initech",
            roleTitle: "Security Engineer",
            status: .applied,
            appliedDate: .now
        )
    )
    context.insert(
        JobApplication(company: "Umbrella", roleTitle: "GRC Analyst", status: .rejected)
    )
    context.insert(
        JobApplication(company: "Wayne Enterprises", roleTitle: "AppSec Engineer", status: .offer)
    )

    return container
}
