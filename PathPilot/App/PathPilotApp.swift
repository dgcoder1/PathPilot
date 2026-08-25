//
//  PathPilotApp.swift
//  PathPilot — App/
//
//  WHAT: The app entry point (@main). Boots SwiftUI and registers SwiftData.
//  WHY:  Every iOS app needs exactly one @main struct. This is where persistence
//        and the root screen are wired together before anything else runs.
//  CONNECTS TO: RootView (first screen), all @Model types (database tables).
//  EDIT WHEN: You add a new SwiftData model — add it to modelContainer(for:).
//

import SwiftData
import SwiftUI

@main
struct PathPilotApp: App {

    var body: some Scene {
        WindowGroup {
            // RootView decides: onboarding vs main tabs.
            RootView()
        }
        // SwiftData only persists types listed here. Register models incrementally
        // (Day 1 core → Day 2 Skill → Day 5 Certification → Day 6 JobApplication).
        .modelContainer(for: [
            UserProfile.self,
            CareerGoal.self,
            Milestone.self,
            Skill.self,
            Certification.self,
            JobApplication.self,
        ])
    }
}
