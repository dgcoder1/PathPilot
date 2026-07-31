//
//  CertificationsListView.swift
//  PathPilot
//
//  Placeholder for the certification tracker (implemented on Day 5).
//

import SwiftUI

struct CertificationsListView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Image(systemName: "rosette")
                    .font(.largeTitle)
                    .foregroundStyle(Color.pathPilotPrimary)

                Text("Coming soon")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pathPilotBackground)
            .navigationTitle("Certifications")
        }
    }
}

#Preview {
    CertificationsListView()
}
