//
//  RootView.swift
//  PathPilot
//
//  Top-level view that decides what the user sees at launch.
//  Day 2 adds an onboarding gate here; for now it shows the main tabs.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    RootView()
}
