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
            UserPrefs.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false) //will set this to false for production
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            //ClubListView()
            DistanceCalcView(modelContext: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }
}
