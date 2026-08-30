//
//  MainTabView.swift
//  PathPilot — Views/
//
//  WHAT: Bottom tab bar with all five main screens.
//  WHY:  Primary navigation after onboarding — one tab per career tracker area.
//  CONNECTS TO: DashboardView, SkillsListView, CertificationsListView,
//               ApplicationsListView, ProfileView.
//  EDIT WHEN: Adding/removing tabs, changing tab icons/labels, or dashboard deep-links.
//

import SwiftUI

/// Which tab is selected. Dashboard cards set this to jump to Skills / Certs / Apps.
enum MainTab: Hashable {
    case dashboard
    case skills
    case certifications
    case applications
    case profile
}

struct MainTabView: View {
    @State private var selectedTab: MainTab = .dashboard

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(selectedTab: $selectedTab)
                .tag(MainTab.dashboard)
                .toolbar(.hidden, for: .tabBar)

            SkillsListView()
                .tag(MainTab.skills)
                .toolbar(.hidden, for: .tabBar)

            CertificationsListView()
                .tag(MainTab.certifications)
                .toolbar(.hidden, for: .tabBar)

            ApplicationsListView()
                .tag(MainTab.applications)
                .toolbar(.hidden, for: .tabBar)

            ProfileView()
                .tag(MainTab.profile)
                .toolbar(.hidden, for: .tabBar)
        }
        .tint(.pathPilotPrimary)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            PathPilotTabBar(selectedTab: $selectedTab)
        }
    }
}

// MARK: - Custom tab bar (matches dashboard mockup: circle highlight on selected)

private struct PathPilotTabBar: View {
    @Binding var selectedTab: MainTab

    var body: some View {
        HStack(spacing: 0) {
            tabButton(.dashboard, title: "Dashboard", icon: "house", selectedIcon: "house.fill")
            tabButton(.skills, title: "Skills", icon: "brain.head.profile", selectedIcon: "brain.head.profile")
            tabButton(.certifications, title: "Certs", icon: "rosette", selectedIcon: "rosette")
            tabButton(.applications, title: "Apps", icon: "briefcase", selectedIcon: "briefcase.fill")
            tabButton(.profile, title: "Profile", icon: "person", selectedIcon: "person.fill")
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .padding(.horizontal, 8)
        .background(Color.pathPilotCard)
        .overlay(alignment: .top) {
            Divider()
        }
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: -2)
    }

    private func tabButton(
        _ tab: MainTab,
        title: String,
        icon: String,
        selectedIcon: String
    ) -> some View {
        let isSelected = selectedTab == tab

        return Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? selectedIcon : icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.pathPilotPrimary : .secondary)
                    .frame(width: 40, height: 32)
                    .background {
                        if isSelected {
                            Capsule()
                                .fill(Color.pathPilotPrimary.opacity(0.12))
                        }
                    }

                Text(title)
                    .font(.caption2.weight(isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? Color.pathPilotPrimary : .secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    MainTabView()
}
