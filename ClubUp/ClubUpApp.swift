//
//  ClubUpApp.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/16/24.
//

import SwiftUI
import SwiftData

@main
struct ClubUpApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Club.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
