//
//  CertificationsListView.swift
//  PathPilot — Views/Certifications/
//
//  WHAT: Certifications tab — list with status badges, add/edit/delete.
//  WHY:  Tracks cert pipeline (Planned → In Progress → Completed) for career progress.
//  CONNECTS TO: CertificationFormView, StatusBadge, EmptyStateView, Certification model.
//  EDIT WHEN: Changing list sort, row layout, or CRUD behavior.
//
//  PATTERN: Mirror this file when building ApplicationsListView CRUD (Tasks 4–6).
//

import SwiftData
import SwiftUI

struct CertificationsListView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Certification.name) private var certifications: [Certification]

    @State private var isShowingAddSheet = false
    @State private var editingCertification: Certification?

    var body: some View {
        NavigationStack {
            Group {
                if certifications.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(certifications) { certification in
                            CertificationRowView(certification: certification) {
                                editingCertification = certification
                            }
                        }
                        .onDelete(perform: deleteCertifications)
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.pathPilotBackground)
            .navigationTitle("Certifications")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { isShowingAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add certification")
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                CertificationFormView()
                    .environment(\.modelContext, modelContext)
            }
            .sheet(item: $editingCertification) { certification in
                CertificationFormView(certification: certification)
                    .environment(\.modelContext, modelContext)
            }
        }
    }

    private var emptyState: some View {
        EmptyStateView(
            systemImage: "rosette",
            title: "No certifications yet",
            message: "Track certs you're planning, studying for, or have earned.",
            buttonTitle: "Add Certification",
            buttonAction: { isShowingAddSheet = true }
        )
    }

    private func deleteCertifications(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(certifications[index])
        }
        do {
            try modelContext.save()
        } catch {
            assertionFailure("Certification delete failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Row (tap name = edit; badge is display-only)

private struct CertificationRowView: View {
    let certification: Certification
    var onEdit: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button { onEdit() } label: {
                Text(certification.name)
                    .foregroundStyle(
                        certification.status == .completed ? .secondary : Color.pathPilotPrimary
                    )
                    .strikethrough(certification.status == .completed, color: .secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .accessibilityHint("Opens certification editor")

            StatusBadge(status: certification.status)
        }
    }
}

// MARK: - Preview

#Preview("With Certifications") {
    CertificationsListView().modelContainer(previewContainer)
}

#Preview("Empty") {
    CertificationsListView().modelContainer(emptyPreviewContainer)
}

private var emptyPreviewContainer: ModelContainer {
    try! ModelContainer(
        for: Certification.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
}

private var previewContainer: ModelContainer {
    let container = try! ModelContainer(
        for: Certification.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    context.insert(Certification(name: "AWS Solutions Architect", status: .inProgress))
    context.insert(Certification(name: "CompTIA Security+", status: .planned))
    context.insert(Certification(name: "Google Cloud Associate", status: .completed))
    return container
}
