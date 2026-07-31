//
//  Color+Theme.swift
//  PathPilot
//
//  Central place for PathPilot brand and semantic colors.
//  Use these instead of hard-coded colors so the app stays consistent
//  and adapts automatically to Light/Dark Mode where noted.
//

import SwiftUI

extension Color {

    /// Deep blue — primary brand color (trust, professionalism).
    /// Hex: #1B3A5C
    static let pathPilotPrimary = Color(red: 0.106, green: 0.227, blue: 0.361)

    /// Teal/green — accent for progress, CTAs, and tab selection.
    /// Hex: #2ECC71
    static let pathPilotAccent = Color(red: 0.180, green: 0.800, blue: 0.443)

    /// Main screen background. Uses Apple's grouped background so it
    /// automatically looks correct in Light and Dark Mode.
    static let pathPilotBackground = Color(.systemGroupedBackground)

    /// Card and row surfaces sitting on top of the background.
    static let pathPilotCard = Color(.secondarySystemBackground)
}

// MARK: - Preview

#Preview("Theme Colors") {
    ScrollView {
        VStack(spacing: 16) {
            ThemeColorSwatch(name: "pathPilotPrimary", color: .pathPilotPrimary)
            ThemeColorSwatch(name: "pathPilotAccent", color: .pathPilotAccent)
            ThemeColorSwatch(name: "pathPilotBackground", color: .pathPilotBackground)
            ThemeColorSwatch(name: "pathPilotCard", color: .pathPilotCard)
        }
        .padding()
    }
    .background(Color.pathPilotBackground)
}

/// Small helper used only in the preview above — not part of the app UI yet.
private struct ThemeColorSwatch: View {
    let name: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 48, height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1)
                )

            Text(name)
                .font(.subheadline.monospaced())

            Spacer()
        }
        .padding()
        .background(Color.pathPilotCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
