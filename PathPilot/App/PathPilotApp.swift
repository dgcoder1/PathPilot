//
//  PathPilotApp.swift
//  PathPilot
//
//  App entry point. Registers SwiftData models and shows the root screen.
//

import SwiftData
import SwiftUI

@main
struct PathPilotApp: App {

    var body: some Scene {
        WindowGroup {
            Text("PathPilot")
        }
        .modelContainer(for: [
            UserProfile.self,
            CareerGoal.self,
            Milestone.self,
        ])
    }
}
