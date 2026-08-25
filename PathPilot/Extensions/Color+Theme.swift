//
//  Color+Theme.swift
//  PathPilot — Extensions/
//
//  WHAT: Brand and semantic color definitions for the whole app.
//  WHY:  One source of truth for colors — change here, updates everywhere.
//        Semantic colors (pathPilotBackground/Card) auto-adapt to Dark Mode.
//  CONNECTS TO: Every view that uses .pathPilotPrimary, .pathPilotAccent, etc.
//  EDIT WHEN: Rebranding or tweaking Light/Dark Mode appearance.
//

import SwiftUI

extension Color {

    /// Deep blue — primary brand color (trust, professionalism).
    /// Hex: #1B3A5C — use for headings, titles, primary text accents.
    static let pathPilotPrimary = Color(red: 0.106, green: 0.227, blue: 0.361)

    /// Teal/green — accent for progress, CTAs, and selected tab bar items.
    /// Hex: #2ECC71 — use for buttons, progress ring, completed states.
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

/// Preview-only helper — not used in the live app.
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
