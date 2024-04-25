//
//  SettingsView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 4/22/24.
//

import SwiftUI

struct SettingsView: View {
    @State var userPrefs: UserPrefs
    @State var isFirst: Bool
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Form {
            Picker("Distance Unit", selection: $userPrefs.distanceUnit) {
                ForEach(Unit.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.inline)
            Picker("Speed Unit", selection: $userPrefs.speedUnit) {
                ForEach(Unit.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.inline)
            Toggle("Favorites", isOn: $userPrefs.favoritesOn)
            Toggle("Shot Tracker", isOn: $userPrefs.trackersOn)
        }
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if (isFirst) {
                        modelContext.insert(userPrefs)
                    }
                    dismiss()
                }, label: {
                    Image(systemName:"chevron.backward")
                        .foregroundStyle(.gray)
                })
            }
        }
    }
}

#Preview {
    let testSettings = UserPrefs.init()
    return SettingsView(userPrefs: testSettings, isFirst: false)
}
