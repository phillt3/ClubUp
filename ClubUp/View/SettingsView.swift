//
//  SettingsView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 4/22/24.
//

import SwiftUI

struct SettingsView: View {
    @State var settings: Settings
    @Environment(\.modelContext) var modelContext
    var body: some View {
        Form {
            Picker("Distance Unit", selection: $settings.distanceUnit) {
                ForEach(Unit.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.inline)
            Picker("Speed Unit", selection: $settings.speedUnit) {
                ForEach(Unit.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.inline)
            Toggle("Favorites", isOn: $settings.favoritesOn)
            Toggle("Shot Tracker", isOn: $settings.trackersOn)
        }
    }
}

#Preview {
    let testSettings = Settings.init()
    return SettingsView(settings: testSettings)
}
